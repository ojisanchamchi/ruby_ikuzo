# frozen_string_literal: true

require "open3"

module Yolo
  # Provides random commit messages grouped by category.
  class Messages
    DEFAULT_CATEGORY = :feat
    DEFAULT_SUBJECT_CATEGORY = :funny
    DEFAULT_CONVENTIONAL_SUBJECT = "update functionality"

    CONVENTIONAL_TYPES = {
      build: "Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)",
      ci: "Changes to CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)",
      chore: "Changes which don't affect source code or tests e.g. build process, auxiliary tools, libraries",
      docs: "Documentation only changes",
      feat: "A new feature",
      fix: "A bug fix",
      perf: "A change that improves performance",
      refactor: "A change that neither fixes a bug nor adds a feature",
      revert: "Revert something",
      style: "Changes that do not affect the meaning of the code (formatting, missing semi-colons, etc.)",
      test: "Adding missing tests or correcting existing tests"
    }.freeze

    STATIC_CATALOG = {
      general: [
        "Ship it! 🚀",
        "Refactor today, thrive tomorrow.",
        "Tests green, vibes high.",
        "Merge dreams into main.",
        "Less yak, more ship. 🪒",
        "Deploy like nobody's watching.",
        "Debugging wizard at work.",
        "Automate the boring brilliance.",
        "Feature flag? More like feature brag.",
        "Keyboard fueled by optimism.",
        "Pixels aligned, spirits lifted.",
        "Compile confidence, execute courage.",
        "Keep calm and push to main 🧘‍♂️",
        "Documentation whispers success.",
        "Breakpoints? Not today!",
        "Commit like you mean it.",
        "Sprint with a smile 🙂",
        "Code, coffee, conquer.",
        "Patching bugs with high-fives.",
        "From TODO to ta-da!"
      ].freeze,
      funny: [
        "It compiled on my machine, scout's honor.",
        "Embracing the chaos-driven-dev methodology.",
        "This commit was pair-programmed with caffeine.",
        "¯\\_(ツ)_/¯ ship first, debug later.",
        "Plot twist: it actually worked.",
        "Stack trace? More like snack trace.",
        "Linted the vibes, not the code.",
        "Documenting bugs as future features.",
        "No rubber duck was harmed in this fix.",
        "Debugger? I barely know her!"
      ].freeze,
      motivation: [
        "Great code starts with this commit.",
        "Refine, refuel, release. 🔁",
        "Iteration builds innovation.",
        "Little wins power big releases.",
        "Stay curious, ship bravely.",
        "Progress is a pull request away.",
        "Keep building, keep believing.",
        "Quality in, confidence out.",
        "Momentum loves momentum.",
        "One more push toward greatness."
      ].freeze,
      dev: [
        "Optimized and ready for prod traffic.",
        "Refactoring debts into assets.",
        "Test coverage just leveled up.",
        "Unlocking feature flags with flair.",
        "API contracts honored, scouts promise.",
        "Latency drops, morale pops.",
        "Logs cleaned, metrics gleam.",
        "DevEx boosted, friction busted.",
        "Main branch stays evergreen.",
        "CI lights are greener than ever."
      ].freeze
    }.freeze

    CONVENTIONAL_CATALOG = CONVENTIONAL_TYPES.each_with_object({}) do |(type, _), hash|
      hash[type] = -> { conventional_message(type) }
    end.freeze

    CATALOG = STATIC_CATALOG.merge(CONVENTIONAL_CATALOG).freeze

    def self.random(category = nil)
      category = normalize_category(category)
      candidates = messages_for(category)
      return candidates.sample unless candidates.empty?

      messages_for(DEFAULT_CATEGORY).sample
    end

    def self.categories
      CATALOG.keys
    end

    def self.conventional_types
      CONVENTIONAL_TYPES.keys
    end

    def self.conventional_type_description(type)
      CONVENTIONAL_TYPES[type.to_sym] if type
    end

    def self.conventional_type?(value)
      return false unless value

      CONVENTIONAL_TYPES.key?(value.to_sym)
    end

    def self.messages_for(category)
      category = normalize_category(category)
      entry = CATALOG.fetch(category) { CATALOG.fetch(DEFAULT_CATEGORY) }
      resolve_entry(entry)
    end

    def self.normalize_category(category)
      return DEFAULT_CATEGORY unless category

      sym = category.to_s.strip.downcase.to_sym
      categories.include?(sym) ? sym : DEFAULT_CATEGORY
    end

    def self.resolve_entry(entry)
      case entry
      when Proc
        value = entry.call
        return resolve_entry(CATALOG.fetch(DEFAULT_CATEGORY)) if value.nil? || (value.respond_to?(:empty?) && value.empty?)

        Array(value)
      when Array
        entry
      else
        Array(entry)
      end
    end
    private_class_method :resolve_entry

    def self.conventional_message(type)
      subject_parts = [branch_subject, sanitized_default_subject].compact.reject(&:empty?)
      subject = subject_parts.join(" ").strip
      subject = DEFAULT_CONVENTIONAL_SUBJECT if subject.empty?
      "#{type}: #{subject}"
    end
    private_class_method :conventional_message

    def self.current_branch
      stdout, status = Open3.capture2("git", "rev-parse", "--abbrev-ref", "HEAD")
      return unless status.success?

      branch = stdout.strip
      return if branch.empty? || branch == "HEAD"

      branch
    rescue StandardError
      nil
    end
    private_class_method :current_branch

    def self.branch_subject
      branch = current_branch
      return unless branch

      short_name = branch.split("/").last
      sanitize_subject(short_name)
    end
    private_class_method :branch_subject

    def self.sanitized_default_subject
      source_category = STATIC_CATALOG.key?(DEFAULT_CATEGORY) ? DEFAULT_CATEGORY : DEFAULT_SUBJECT_CATEGORY
      entry = STATIC_CATALOG[source_category] || STATIC_CATALOG[DEFAULT_SUBJECT_CATEGORY]
      return unless entry

      candidates = resolve_entry(entry)
      message = candidates.sample
      sanitized = sanitize_subject(message)
      sanitized unless sanitized.empty?
    end
    private_class_method :sanitized_default_subject

    def self.sanitize_subject(value)
      return "" unless value

      value
        .to_s
        .downcase
        .gsub(/[^a-z0-9\s\-]/, " ")
        .gsub(/\s+/, " ")
        .strip
    end
    private_class_method :sanitize_subject
  end
end
