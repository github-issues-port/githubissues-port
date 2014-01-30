# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'githubissues-port/version'

Gem::Specification.new do |spec|
  spec.name          = "githubissues-port"
  spec.version       = Githubissues::Port::VERSION
  spec.authors       = ["pythonicrubyist", "ankit8898", "hemalijain"]
  spec.email         = ["pythonicrubyist@gmail.com"]
  spec.description   = %q{An Excel import/export extension for github issues for Ruby.}
  spec.summary       = %q{github-issues-port is a Ruby gem that facilittes easy import and export of Github Issues in Ruby and Ruyb on Rails.}
  spec.homepage      = "https://github.com/github-issues-port/github-issues-port"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.2'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 2.13.0'

  spec.add_dependency 'github_api'
  spec.add_dependency 'axlsx' 
  spec.add_dependency 'creek'  
end
