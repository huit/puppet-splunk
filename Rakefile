require 'rubygems'
require 'puppet-lint'
require 'puppetlabs_spec_helper/rake_tasks'

PuppetLint.configuration.ignore_paths = ["pkg/**/*.pp", "tests/*.pp"]
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_documentation')
task :default => [:spec, :lint]
