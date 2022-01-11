require_relative "lib/notable/version"

Gem::Specification.new do |spec|
  spec.name          = "notable"
  spec.version       = Notable::VERSION
  spec.summary       = "Track notable requests and background jobs"
  spec.homepage      = "https://github.com/ankane/notable"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{app,lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.6"

  spec.add_dependency "activesupport", ">= 5.2"
  spec.add_dependency "safely_block", ">= 0.1.1"
end
