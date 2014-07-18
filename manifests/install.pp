class splunk::install (
  $license          = $::splunk::license,
  $pkgname          = $::splunk::pkgname,
  $splunkadmin      = $::splunk::splunkadmin,
  $localusers       = $::splunk::localusers,
  $SPLUNKHOME       = $::splunk::SPLUNKHOME,
  $type             = $::splunk::type,
  $version          = $::splunk::version,
  $package_source   = $::splunk::package_source,
  $package_provider = $::splunk::package_provider,
  ) {

  package { "${pkgname}":
    ensure   => $version,
    provider => $package_provider,
    source   => $package_source,
  }->

  file { '/etc/init.d/splunk':
    ensure  => present,
    mode    => '0700',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/splunk/${::osfamily}/etc/init.d/${pkgname}"
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
    path    => "${SPLUNKHOME}/etc/system/local/server.conf",
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
  # This is causing a restart on the second run. - TODO
  file { "${SPLUNKHOME}/etc/auth":
      mode    => '0600',
      owner   => 'splunk',
      group   => 'splunk',
      recurse => true,
      purge   => false,
      source  => 'puppet:///modules/splunk/noarch/opt/splunk/etc/auth',
  }
}
