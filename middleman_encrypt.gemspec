# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman_encrypt/version'

Gem::Specification.new do |spec|
  spec.name          = "middleman_encrypt"
  spec.version       = MiddlemanEncrypt::VERSION
  spec.authors       = ["Matt Snider"]
  spec.email         = ["msnider@ucla.edu"]
  spec.summary       = %q{Create encrypted webpages that can be decrypted client-side with a password.}
  spec.description   = %q{Create a static website with password protected pages by encrypting during the build step and decrypting with a password client-side.}
  spec.homepage      = "https://github.com/msnider/middleman_encrypt"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "middleman-core", "~> 3.3"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
