# == Defined Type: splunk::ta::files
# splunk::ta::files will install a TA from the file bucket bucket from the
# Splunk Module, or mor correctly from the site/ Splunk Module
#
# === Parameters
#
# Document parameters here.
#      
# [configfile]
#   Path to extracted Splunk TA on the Puppet Master.
#      
# [status]
#   App Status. Defaults to enabled
#      
define splunk::ta::files (
  $configfile = "puppet:///modules/splunk/ta/${title}",
  $status     = 'enabled',
  $SPLUNKHOME = $::splunk::SPLUNKHOME
) {
  file { "${SPLUNKHOME}/etc/apps/${title}":
    ensure  => present,
    owner   => 'splunk',
    group   => 'splunk',
    recurse => true,
    purge   => false,
    source  => $configfile,
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
  } ->
  file { "${SPLUNKHOME}/etc/apps/${title}/local":
    ensure => directory,
  }
  file { "${SPLUNKHOME}/etc/apps/${title}/local/app.conf":
    ensure => file,
    owner  => 'splunk',
    group  => 'splunk',
    mode   => '0644',
  } ->
  ini_setting { 'Enable Splunk LWF':
    path    => "${SPLUNKHOME}/etc/apps/${title}/local/app.conf",
    section => 'install',
    setting => 'state',
    value   => $status,
    ensure  => present,
  }
}
