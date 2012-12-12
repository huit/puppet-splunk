class splunk::params {
  $CONFIGVERSION    = '229'
  $COLLECTORVERSION = '162'
  $MOMVERSION       = '217'
  $MAPSVERSION      = '114'
  $splunkadmin      = $::unsg_common::splunkadmin
  $localusers       = $::unsg_common::splunklocal
  $proxyserver      = $::unsg_common::proxyserver
  #$localusers       = undef
  $vcsusr           = $::unsg_common::svn_usr
  $vcspw            = $::unsg_common::svn_pw
  $vcscmd           = 'svn info --config-option servers:global:store-plaintext-passwords=yes --non-interactive --username  puppetsvn'
  $vcsurl           = 'https://svn.noc.harvard.edu/unsg'
  $type             = undef

  if ( $::environment == development ) {
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
