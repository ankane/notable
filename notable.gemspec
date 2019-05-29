
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "notable/version"

Gem::Specification.new do |spec|
  spec.name          = "notable"
  spec.version       = Notable::VERSION
  spec.summary       = "Track notable requests and background jobs"
  spec.homepage      = "https://github.com/ankane/notable"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@chartkick.com"

  spec.files         = Dir["*.{md,txt}", "{app,lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.4"

  spec.add_dependency "request_store"
  spec.add_dependency "safely_block", ">= 0.1.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
