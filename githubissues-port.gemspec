# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'githubissues-port/version'

Gem::Specification.new do |spec|
  spec.name          = "githubissues-port"
  spec.version       = Githubissues::Port::VERSION
  spec.authors       = ["Ramtin Vaziri", "Ankit gupta", "Hemali Jain"]
  spec.description   = %q{An Excel import/export extension for github issues in Ruby.}
  spec.summary       = %q{github-issues-port is a Ruby gem that facilittes easy import and export of Github Issues in Ruby and Ruyb on Rails.}
  spec.homepage      = "https://github.com/github-issues-port/githubissues-port"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.2'

  spec.add_dependency 'github_api'
  spec.add_dependency 'creek'
  spec.add_dependency 'axlsx','~> 2.0.1'
  spec.add_development_dependency 'rake', '~>10.1.1'
  spec.add_development_dependency 'rspec'
end
