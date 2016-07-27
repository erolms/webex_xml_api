# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webex_xml_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'webex_xml_api'
  spec.version       = WebexXmlApi::VERSION
  spec.authors       = ['Erol Zavidic']
  spec.email         = ['erolms@googlemail.com']
  spec.cert_chain    = ['certs/erolms.pem']
  spec.signing_key   = File.expand_path('~/.gem/gem-private_key.pem') if $0 =~ /gem\z/

  spec.summary       = 'WebEx XML API integration gem'
  spec.description   = 'Ruby gem for Cisco WebEx integration using XML API interface'
  spec.homepage      = 'https://github.com/erolms/webex_xml_api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty'
  spec.add_dependency 'nokogiri'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'
end
