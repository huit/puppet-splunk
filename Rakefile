require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint'
require 'puppet-syntax'

PuppetSyntax.exclude_paths = ["files/**/*", "pkg/**/*"]
PuppetLint.configuration.ignore_paths = ["pkg/**/*.pp", "tests/*.pp", "files/**/*.html"]
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
task :default => [:lint, :syntax, :spec]
