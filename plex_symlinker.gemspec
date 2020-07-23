require_relative "lib/plex_symlinker/version"

Gem::Specification.new do |spec|
  spec.name          = "plex_symlinker"
  spec.version       = PlexSymlinker::VERSION
  spec.authors       = ["Stefan Exner"]
  spec.email         = ["stex@sterex.de"]

  spec.summary       = "Summary"
  spec.description   = "Description"
  spec.homepage      = "https://github.com/stex/plex_symlinker"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/stex/plex_symlinker"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) } rescue []
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "~> 6.0"
  spec.add_runtime_dependency "ruby-progressbar", "~> 1.10"
  spec.add_runtime_dependency "slop", "~> 4.8"
  spec.add_runtime_dependency "taglib-ruby", "~> 1.0"
  spec.add_runtime_dependency "zeitwerk", "~> 2.4"

  spec.add_development_dependency "pry", "~> 0.13.1"
  spec.add_development_dependency "standard", "~> 0.4"
end
