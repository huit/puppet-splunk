class splunk::params {
  $index            = 'os'
  $index_hash       = { }
  $nagios_contacts  = undef
  $splunkadmin      = ':admin:$1$QfZoXMjP$jafmv2ASM45lllqaXHeXv/::Administrator:admin:changeme@example.com:'
  $target_group     = { example1 => 'server1.example.com',
                        example2 => 'server2.example.com' }
  $type             = 'uf'
  $localusers       = undef
  $output_hash      = { }
  $port             = '9997'
  $proxyserver      = undef
  $purge            = undef
  $version          = 'installed'
  $rbenv_plugins    = [ 'sstephenson/rbenv-vars', 'sstephenson/ruby-build' ]
  $ruby_version     = '1.9.3-p448'
  $ruby_gems        = [ 'splunk-sdk-ruby' ]

  if $::mode == maintenance {
    $service_ensure = 'stopped'
    $service_enable = false
  } else {
    $service_ensure = 'running'
    $service_enable = true
  }
}
