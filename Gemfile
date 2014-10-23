source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 2.7']
end

gem 'rake'
gem 'requests'
gem 'puppet-lint'
gem 'puppet-syntax'
gem 'beaker'
gem 'beaker-rspec'
gem 'rspec-puppet', '>= 1.0.0'
gem 'puppetlabs_spec_helper'
gem 'puppet', puppetversion
