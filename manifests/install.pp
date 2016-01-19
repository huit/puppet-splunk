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
  $replace_passwd   = $::splunk::replace_passwd,
  $user             = $::splunk::user,
  $group            = $::splunk::group,
  $init_system      = $::splunk::init_system,
  $init_confdir     = $::splunk::init_confdir,
  ) {

  package { $pkgname:
    ensure   => $version,
    provider => $package_provider,
    source   => $package_source,
  }->

  file { "${splunkhome}/etc/splunk-launch.conf":
    ensure  => present,
    mode    => '0444',
    owner   => $user,
    group   => $group,
    backup  => true,
    content => template('splunk/opt/splunk/etc/splunk-launch.conf.erb'),
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
    owner   => $user,
    group   => $group,
    backup  => true,
    content => template('splunk/opt/splunk/etc/passwd.erb'),
  } ->

  # recursively copy the contents of the auth dir
  # This is causing a restart on the second run. - TODO
  file { "${splunkhome}/etc/auth":
      mode    => '0600',
      owner   => 'splunk',
      group   => 'splunk',
      recurse => true,
      purge   => false,
      source  => 'puppet:///modules/splunk/noarch/opt/splunk/etc/auth',
  }

  # On operatingsystems that use init scripts, include the configuration file
  # Separate from the above dependency chain because it might not exist
  if $init_system == 'sysv_compat' {
    file { "${init_confdir}/${pkgname}":
      ensure  => present,
      mode    => '0700',
      owner   => 'root',
      group   => 'root',
      content => template('splunk/init_conf.erb'),
      require => Package[$pkgname],
    } ->

    file { '/etc/init.d/splunk':
      ensure => present,
      mode   => '0700',
      owner  => 'root',
      group  => 'root',
      source => "puppet:///modules/splunk/${::osfamily}/etc/init.d/${pkgname}"
    }
  }
  elsif $init_system == 'smf' {
    file { '/var/svc/manifest/site/splunk.smf.xml':
      content => template('splunk/Solaris/splunk.smf.xml.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      require => Package[$pkgname],
      notify  => Exec['splunk-smf-importer'];
    }

    exec { 'splunk-smf-importer':
      refreshonly => true,
      command     => '/usr/sbin/svcadm restart manifest-import';

    }
  }

}
