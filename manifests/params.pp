class splunk::params {
  $type             = 'lwf'
  $nagios_contacts  = undef
  $splunkadmin      = ':admin:$1$QfZoXMjP$jafmv2ASM45lllqaXHeXv/::Administrator:admin:changeme@example.com:'
  $localusers       = undef
  $proxyserver      = hiera('proxyserver', undef )
  $purge            = undef
  $version          = 'installed'

  case $type {
    'uf': {
      $pkgname    = 'splunkforwarder'
      $SPLUNKHOME = '/opt/splunkforwarder'
      $license    = undef
    }
    'hfw,lwf': {
      $SPLUNKHOME = '/opt/splunk'
      $pkgname    = 'splunk'
      $license    = 'puppet:///modules/splunk/noarch/opt/splunk/etc/splunk-forwarder.license'
    }
    default: { 
      $SPLUNKHOME = '/opt/splunk'
      $pkgname    = 'splunk'
      $license    = undef
    }
  }

  if $::mode == maintenance {
    $ensurestat = 'stopped'
    $enablestat = 'false'
  } else {
    $ensurestat = 'running'
    $enablestat = 'true'
  }
}
