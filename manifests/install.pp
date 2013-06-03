class splunk::install (
  $splunkadmin = $::splunk::splunkadmin,
  $type        = $::splunk::type,
  $version     = 'installed'
  ) {
  if ( $type == 'lwf' ) {
    $license = 'puppet:///modules/splunk/noarch/opt/splunk/etc/splunk-forwarder.license'
    $pkgname = 'splunk'
  }
  elsif ( $type == 'uf' ) {
    $license = undef
    $pkgname = 'splunkforwarder'
  } else {
    $license = undef
    $pkgname = 'splunk'
  }

  package { "$pkgname":
    ensure   => $version,
    notify   => Exec['preseed-server.conf'],
  } ->

  file { '/etc/init.d/splunk':
    ensure  => present,
    mode    => '0700',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/splunk/etc/init.d/$pkgname",
  }

  # Can this be replaced with ini_setting type?
  exec { 'preseed-server.conf':
    command     => "/bin/echo -e \"[general]\nserverName = $::fqdn\" >/opt/$pkgname/etc/system/local/server.conf",
    refreshonly => 'true',
    notify      => Service['splunk'],
  } ->

  # inifile
  ini_setting { 'Server Name':
    ensure  => present,
    path    => "/opt/$pkgname/etc/system/local/server.conf",
    section => 'general',
    setting => 'serverName',
    value   => $::fqdn,
  }
  ini_setting { 'SSL v3 only':
    ensure  => present,
    path    => "/opt/$pkgname/etc/system/local/server.conf",
    section => 'general',
    setting => 'sslConfig',
    value   => 'supportSSLV3Only True',
  }

  file { "/opt/$pkgname/etc/splunk.license":
    ensure  => present,
    mode    => '0644',
    owner   => 'splunk',
    group   => 'splunk',
    backup  => true,
    source  => $license,
  }
    
  file { "/opt/$pkgname/etc/passwd":
    ensure   => present,
    mode     => '0600',
    owner    => 'root',
    group    => 'root',
    backup   => true,
    content  => template('splunk/opt/splunk/etc/passwd.erb'),
  }

  # recursively copy the contents of the auth dir
  file { "/opt/$pkgname/etc/auth":
      mode    => '0600',
      owner   => 'splunk',
      group   => 'splunk',
      recurse => true,
      purge   => false,
      source  => 'puppet:///modules/splunk/noarch/opt/splunk/etc/auth',
  }
  service {
    'splunk':
      ensure     => $::splunk::ensurestat,
      enable     => $::splunk::enablestat,
      hasrestart => true,
      hasstatus  => false,
      pattern    => 'splunkd',
  }
}
