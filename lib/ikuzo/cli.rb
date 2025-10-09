# frozen_string_literal: true

require "optparse"

module Ikuzo
  # CLI entry point for generating random commit messages.
  class CLI
    def initialize(argv, stdout: $stdout, stderr: $stderr, kernel: Kernel)
      @argv = argv.dup
      @stdout = stdout
      @stderr = stderr
      @kernel = kernel
    end

    def run
      options = parse_options

      if options[:list_categories]
        print_categories
        return exit_success
      end

      message = Messages.random(options[:category])
      @stdout.puts(message)

      return exit_success unless options[:commit]

      commit_with(message)
    rescue OptionParser::ParseError => e
      @stderr.puts(e.message)
      @stderr.puts(option_parser.summarize.join)
      exit_failure
    end

    private

    def parse_options
      options = {
        commit: false,
        list_categories: false,
        category: nil
      }

      categories_text = Messages.categories.join(", ")
      option_parser.on("-cCATEGORY", "--category=CATEGORY", "Filter by category (#{categories_text}). Default: #{Messages::DEFAULT_CATEGORY}") do |category|
        options[:category] = category
      end

      option_parser.on("--commit", "Run `git commit -m` with the generated message") do
        options[:commit] = true
      end

      option_parser.on("--list-categories", "List available message categories") do
        options[:list_categories] = true
      end

      option_parser.on("-v", "--version", "Print version") do
        @stdout.puts(Ikuzo::VERSION)
        exit_success
      end

      option_parser.on("-h", "--help", "Show this help message") do
        @stdout.puts(option_parser)
        exit_success
      end

      option_parser.parse!(@argv)
      apply_positional_arguments(options)
      options
    end

    def option_parser
      @option_parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: ikuzo [options] [category] [commit]"
        opts.separator("")
        opts.separator("Examples:")
        opts.separator("  ikuzo")
        opts.separator("  ikuzo funny")
        opts.separator("  ikuzo feat")
        opts.separator("  ikuzo fix")
        opts.separator("  ikuzo dev --commit")
        opts.separator("  ikuzo --category motivation")
      end
    end

    def apply_positional_arguments(options)
      @argv.each do |arg|
        normalized = arg.to_s.strip.downcase
        next if normalized.empty?

        if category_argument?(normalized) && options[:category].nil?
          options[:category] = normalized
        elsif normalized == "commit"
          options[:commit] = true
        end
      end
    end

    def category_argument?(value)
      Messages.categories.include?(value.to_sym)
    end

    def commit_with(message)
      success = @kernel.system("git", "commit", "-m", message)
      return exit_success if success

      @stderr.puts("git commit failed. Please ensure you're inside a Git repository with staged changes.")
      exit_failure
    end

    def print_categories
      @stdout.puts("Available categories:")
      Messages.categories.each do |category|
        description = Messages.conventional_type_description(category)
        if description
          @stdout.puts("  - #{category} - #{description}")
        else
          @stdout.puts("  - #{category}")
        end
      end
    end

    def exit_success
      @kernel.exit(0)
    end

    def exit_failure
      @kernel.exit(1)
    end
  end
end
