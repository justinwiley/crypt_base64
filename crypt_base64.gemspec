# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crypt_base64/version'

Gem::Specification.new do |spec|
  spec.name          = "crypt_base64"
  spec.version       = CryptBase64::VERSION
  spec.authors       = ["Justin Wiley"]
  spec.email         = ["justin.wiley@gmail.com"]
  spec.description   = %q{CryptBase64 wraps OpenSSL AES, serializing to and from Base64.}
  spec.summary       = %q{CryptBase64 wraps OpenSSL AES, serializing to and from Base64.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
