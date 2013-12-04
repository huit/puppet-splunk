require 'rubygems'
require 'puppet-lint'
require 'puppetlabs_spec_helper/rake_tasks'

PuppetLint.configuration.ignore_paths = ["pkg/**/*.pp"]
PuppetLint.configuration.send('disable_80chars')
task :default => [:spec, :lint]
