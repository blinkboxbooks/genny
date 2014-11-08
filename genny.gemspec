# -*- encoding: utf-8 -*-
__dir__ = File.expand_path(File.join(__FILE__, ".."))
$LOAD_PATH.unshift(File.join(__dir__, "lib"))

Gem::Specification.new do |gem|
  gem.name          = "genny"
  gem.version       = begin
                        File.read(File.join(__dir__, "VERSION"))
                      rescue Errno::ENOENT
                        "0.0.0-unknown"
                      end
  gem.authors       = ["JP Hastings-Spital"]
  gem.email         = ["jphastings@gmail.com"]
  gem.description   = %q{Genny likes to make things up. It generates ruby objects, mainly from JSON Schema.}
  gem.summary       = %q{Genny likes to make things up. It generates ruby objects, mainly from JSON Schema.}
  gem.homepage      = "https://github.com/blinkboxbooks/genny"

  gem.files         = Dir["lib/**/*.rb","VERSION"]
  gem.extra_rdoc_files = Dir["**/*.md"]
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~>3.0"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "json-schema"
  gem.add_development_dependency "codeclimate-test-reporter"
end
