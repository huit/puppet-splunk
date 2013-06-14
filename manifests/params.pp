class splunk::params {
  $nagios_contacts  = undef
  $splunkadmin      = ':admin:$1$QfZoXMjP$jafmv2ASM45lllqaXHeXv/::Administrator:admin:changeme@example.com:'
  $target_group     = { example1 => 'server1.example.com',
                        example2 => 'server2.example.com' }
  $type             = 'uf'
  $localusers       = undef
  $port             = '9997'
  $proxyserver      = hiera('proxyserver', undef )
  $purge            = undef
  $version          = 'installed'

  if $::mode == maintenance {
    $ensurestat = 'stopped'
    $enablestat = 'false'
  } else {
    $ensurestat = 'running'
    $enablestat = 'true'
  }
}
