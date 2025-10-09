require_relative "lib/yolo/version"

Gem::Specification.new do |spec|
  spec.name          = "yolo"
  spec.version       = Yolo::VERSION
  spec.authors       = ["Dang Quang Minh"]
  spec.email         = ["ojisanchamchi@gmail.com"]

  spec.summary       = "Generate fun, motivational commit messages."
  spec.description   = "Yolo delivers short, humorous, and motivational commit messages for developers via both CLI and library usage."
  spec.homepage      = "https://github.com/ojisanchamchi/ruby_yolo"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.7"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ojisanchamchi/ruby_yolo"
  spec.metadata["changelog_uri"] = "https://github.com/ojisanchamchi/ruby_yolo/releases"

  spec.files         = Dir.glob("lib/**/*.rb") + %w[README.md LICENSE yolo.gemspec bin/yolo]
  spec.bindir        = "bin"
  spec.executables   = ["yolo"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake"
end
