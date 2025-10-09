require_relative "lib/ikuzo/version"

Gem::Specification.new do |spec|
  spec.name          = "ikuzo"
  spec.version       = Ikuzo::VERSION
  spec.authors       = ["Dang Quang Minh"]
  spec.email         = ["ojisanchamchi@gmail.com"]

  spec.summary       = "Generate convention-ready commit messages without overthinking them."
  spec.description   = "Ikuzo delivers short, humorous, and motivational commit messages so you can satisfy Conventional Commit lint rules and get back to coding—life is short, take time to code—whether you call it from the CLI or as a library."
  spec.homepage      = "https://github.com/ojisanchamchi/ruby_ikuzo#readme"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ojisanchamchi/ruby_ikuzo"
  spec.metadata["changelog_uri"] = "https://github.com/ojisanchamchi/ruby_ikuzo/releases"

  spec.files         = Dir.glob("lib/**/*.rb") + %w[README.md LICENSE ikuzo.gemspec bin/ikuzo]
  spec.bindir        = "bin"
  spec.executables   = ["ikuzo"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
