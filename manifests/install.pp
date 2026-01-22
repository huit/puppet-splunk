class splunk::install (
  $license          = $::splunk::license,
  $pkgname          = $::splunk::pkgname,
  $splunkadmin      = $::splunk::splunkadmin,
  $localusers       = $::splunk::localusers,
  $splunkhome       = $::splunk::splunkhome,
  $type             = $::splunk::type,
  $version          = $::splunk::version,
  $package_source   = $::splunk::package_source,
  $package_provider = $::splunk::package_provider,
  $replace_passwd   = $::splunk::replace_passwd
  ) {

  package { $pkgname:
    ensure   => $version,
    provider => $package_provider,
    source   => $package_source,
  }->

  file { '/etc/init.d/splunk':
    ensure => present,
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/splunk/${::osfamily}/etc/init.d/${pkgname}"
  } ->

  # inifile
  ini_setting { 'Server Name':
    ensure  => present,
    path    => "${splunkhome}/etc/system/local/server.conf",
    section => 'general',
    setting => 'serverName',
    value   => $::fqdn,
  } ->
  ini_setting { 'SSL v3 only':
    ensure  => present,
    path    => "${splunkhome}/etc/system/local/server.conf",
    section => 'sslConfig',
    setting => 'supportSSLV3Only',
    value   => 'True',
  } ->

  file { "${splunkhome}/etc/splunk.license":
    ensure => present,
    mode   => '0644',
    owner  => 'splunk',
    group  => 'splunk',
    backup => true,
    source => $license,
  } ->

  file { "${splunkhome}/etc/passwd":
    ensure  => present,
    replace => $replace_passwd,
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    backup  => true,
    content => template('splunk/opt/splunk/etc/passwd.erb'),
  }

}
