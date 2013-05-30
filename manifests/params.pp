class splunk::params {
  $type             = undef
  $nagios_contacts  = undef
  $splunkadmin      = ':admin:$1$QfZoXMjP$jafmv2ASM45lllqaXHeXv/::Administrator:admin:changeme@example.com:'
  $localusers       = undef
  $proxyserver      = hiera('proxyserver', undef )

  # note sure if the env stuff is going to be needed
  if ( $::environment == 'development' ) {
    $nagiosserver = $::unsg_common::nagios_dev
  } else {
    $nagiosserver = $::unsg_common::nagiosserver
  }

  if $::mode == maintenance {
    $ensurestat = 'stopped'
    $enablestat = 'false'
  } else {
    $ensurestat = 'running'
    $enablestat = 'true'
  }
}
