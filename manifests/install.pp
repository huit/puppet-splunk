class splunk::install (
  $license     = $::splunk::license,
  $pkgname     = $::splunk::pkgname,
  $splunkadmin = $::splunk::splunkadmin,
  $localusers  = $::splunk::splunkadmin,
  $SPLUNKHOME  = $::splunk::SPLUNKHOME,
  $type        = $::splunk::type,
  $version     = $::splunk::version
  ) {

  package { "$pkgname":
    ensure   => $version,
  } ->

  file { '/etc/init.d/splunk':
    ensure  => present,
    mode    => '0700',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/splunk/etc/init.d/$pkgname",
  } ->

  # inifile
  ini_setting { 'Server Name':
    ensure  => present,
    path    => "${SPLUNKHOME}/etc/system/local/server.conf",
    section => 'general',
    setting => 'serverName',
    value   => $::fqdn,
  } ->
  ini_setting { 'SSL v3 only':
    ensure  => present,
    path    => "$SPLUNKHOME/etc/system/local/server.conf",
    section => 'sslConfig',
    setting => 'supportSSLV3Only',
    value   => 'True',
  } ->

  file { "${SPLUNKHOME}/etc/splunk.license":
    ensure  => present,
    mode    => '0644',
    owner   => 'splunk',
    group   => 'splunk',
    backup  => true,
    source  => $license,
  } -> 
    
  file { "${SPLUNKHOME}/etc/passwd":
    ensure   => present,
    mode     => '0600',
    owner    => 'root',
    group    => 'root',
    backup   => true,
    content  => template('splunk/opt/splunk/etc/passwd.erb'),
  } ->

  # recursively copy the contents of the auth dir
  file { "${SPLUNKHOME}/etc/auth":
      mode    => '0600',
      owner   => 'splunk',
      group   => 'splunk',
      recurse => true,
      purge   => false,
      source  => 'puppet:///modules/splunk/noarch/opt/splunk/etc/auth',
  } -> 
  service {
    'splunk':
      ensure     => $::splunk::ensurestat,
      enable     => $::splunk::enablestat,
      hasrestart => true,
      pattern    => 'splunkd',
  }
}
