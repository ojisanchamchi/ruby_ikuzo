# frozen_string_literal: true

require "net/http"
require "json"
require "uri"
require "openssl"
require "open3"

module Ikuzo
  # Fetches cryptocurrency and metal pricing information for use in commit messages.
  class Pricing
    DEFAULT_CURRENCY = "USD"
    COINGECKO_ENDPOINT = "https://api.coingecko.com/api/v3/simple/price"

    SUPPORTED_ASSETS = {
      btc: { id: "bitcoin", label: "BTC", provider: :coingecko },
      xau: { symbol: "XAU", label: "XAU", provider: :metal }
    }.freeze

    def self.suffix_for(asset, currency: DEFAULT_CURRENCY)
      asset = asset.to_sym
      return unless SUPPORTED_ASSETS.key?(asset)

      price = fetch_price(asset, currency: currency)
      return unless price

      "#{suffix_prefix(asset)} #{format_amount(price, currency)}"
    end

    def self.fetch_price(asset, currency: DEFAULT_CURRENCY)
      info = SUPPORTED_ASSETS.fetch(asset)
      case info.fetch(:provider)
      when :coingecko
        fetch_coingecko_price(info.fetch(:id), currency)
      when :metal
        fetch_metal_price(currency)
      else
        nil
      end
    end
    private_class_method :fetch_price

    def self.fetch_coingecko_price(asset_id, currency)
      response = request_coingecko_price(asset_id, currency: currency)
      response = request_coingecko_price_via_curl(asset_id, currency: currency) if response.nil? && curl_available?
      return unless response

      asset_data = response[asset_id] || response[asset_id.to_sym]
      return unless asset_data.is_a?(Hash)

      lookup_key = currency.downcase
      value = asset_data[lookup_key]
      return unless value
      Float(value)
    rescue ArgumentError
      nil
    end
    private_class_method :fetch_coingecko_price

    def self.fetch_metal_price(currency)
      return unless currency.upcase == DEFAULT_CURRENCY

      uri = URI("https://data-asg.goldprice.org/dbXRates/#{currency.upcase}")
      response = http_get(uri)
      return unless response.is_a?(Net::HTTPSuccess)

      data = JSON.parse(response.body)
      items = data["items"]
      return unless items.is_a?(Array) && !items.empty?

      value = items.first["xauPrice"]
      Float(value)
    rescue StandardError
      nil
    end
    private_class_method :fetch_metal_price

    def self.request_coingecko_price(asset_id, currency: DEFAULT_CURRENCY)
      uri = URI(COINGECKO_ENDPOINT)
      uri.query = URI.encode_www_form(ids: asset_id, vs_currencies: currency.downcase)

      response = http_get(uri)
      return unless response

      return unless response.is_a?(Net::HTTPSuccess)

      data = JSON.parse(response.body)
      data
    rescue StandardError
      nil
    end
    private_class_method :request_coingecko_price

    def self.request_coingecko_price_via_curl(asset_id, currency: DEFAULT_CURRENCY)
      uri = URI(COINGECKO_ENDPOINT)
      uri.query = URI.encode_www_form(ids: asset_id, vs_currencies: currency.downcase)

      stdout, status = Open3.capture2("curl", "-sS", uri.to_s)
      return nil unless status.success?

      JSON.parse(stdout)
    rescue StandardError
      nil
    end
    private_class_method :request_coingecko_price_via_curl

    def self.http_get(uri)
      insecure = insecure_ssl?
      response = perform_http_get(uri, verify: !insecure)
      response
    rescue OpenSSL::SSL::SSLError
      unless insecure
        return perform_http_get(uri, verify: false)
      end
      nil
    rescue StandardError
      nil
    end
    private_class_method :http_get

    def self.perform_http_get(uri, verify:)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.open_timeout = 5
      http.read_timeout = 5
      if http.use_ssl?
        if verify
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
          http.cert_store = default_cert_store
        else
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end

      request = Net::HTTP::Get.new(uri)
      request["User-Agent"] = USER_AGENT
      request["Accept"] = "application/json"

      http.request(request)
    end
    private_class_method :perform_http_get

    USER_AGENT = "Ikuzo CLI/1.0"

    def self.insecure_ssl?
      ENV.fetch("IKUZO_INSECURE_SSL", "1") != "0"
    end
    private_class_method :insecure_ssl?

    def self.default_cert_store
      @default_cert_store ||= OpenSSL::X509::Store.new.tap do |store|
        store.set_default_paths
      end
    end
    private_class_method :default_cert_store

    def self.curl_available?
      @curl_available ||= system("command -v curl > /dev/null 2>&1")
    end
    private_class_method :curl_available?

    def self.suffix_prefix(asset)
      "(#{SUPPORTED_ASSETS.fetch(asset).fetch(:label)}:"
    end
    private_class_method :suffix_prefix

    def self.format_amount(value, currency)
      formatted_number = delimited(format("%.2f", value))
      "#{currency_symbol(currency)}#{formatted_number})"
    end
    private_class_method :format_amount

    def self.delimited(value)
      integer, fraction = value.split(".")
      integer_with_commas = integer.gsub(/(\d)(?=(\d{3})+(?!\d))/, "\\1,")
      [integer_with_commas, fraction].compact.join(".")
    end
    private_class_method :delimited

    def self.currency_symbol(currency)
      currency.upcase == "USD" ? "$" : "#{currency.upcase} "
    end
    private_class_method :currency_symbol
  end
end
