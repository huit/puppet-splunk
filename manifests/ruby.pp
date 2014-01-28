# Class:: splunk::ruby
#
#
class splunk::ruby (
  $rbenv_plugins = $splunk::params::rbenv_plugins,
  $ruby_gems     = $splunk::params::ruby_gems,
  $ruby_version  = $splunk::params::ruby_version,
) inherits splunk::params {

  class { 'rbenv': }

  rbenv::plugin { $splunk::ruby::rbenv_plugins: }

  rbenv::build { $splunk::ruby::ruby_version: }

  rbenv::gem { 'splunk-sdk-ruby':
    ruby_version => $splunk::ruby::ruby_version,
  }

} # Class:: splunk::ruby
