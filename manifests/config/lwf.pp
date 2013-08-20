#Private Class to enable/disable LWF
class splunk::config::lwf (
  $SPLUNKHOME = $::splunk::SPLUNKHOME,
  $status  = 'enabled'
  ) {
  file { "${SPLUNKHOME}/etc/apps/SplunkLightForwarder/local":
    ensure => 'directory',
    owner  => 'splunk',
    group  => 'splunk',
    require => Class['splunk::install'],
  }
  file { "${SPLUNKHOME}/etc/apps/SplunkLightForwarder/local/app.conf":
    ensure => file,
    owner  => 'splunk',
    group  => 'splunk',
    mode   => '0644',
    require => Class['splunk::install'],
  } ->
  ini_setting { 'Enable Splunk LWF':
    ensure  => present,
    path    => "${SPLUNKHOME}/etc/apps/SplunkLightForwarder/local/app.conf",
    section => 'install',
    setting => 'state',
    value   => $status,
    require => Class['splunk::install'],
  }
}
