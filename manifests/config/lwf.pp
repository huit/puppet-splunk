#Private Class to enable/disable LWF
class splunk::config::lwf (
  $SPLUNKHOME = $::splunk::SPLUNKHOME,
  $status  = 'enabled'
  ) {
  ini_setting { 'Disable Web Server':
    path    => "${SPLUNKHOME}/etc/system/local/server.conf",
    section => 'httpServer',
    setting => 'disableDefaultPort',
    value   => 'True',
    ensure  => present,
  }
  file { "${SPLUNKHOME}/etc/apps/SplunkLightForwarder/local":
    ensure => 'directory',
    owner  => 'splunk',
    group  => 'splunk',
  }
  file { "${SPLUNKHOME}/etc/apps/SplunkLightForwarder/local/app.conf":
    ensure => file,
    owner  => 'splunk',
    group  => 'splunk',
    mode   => '0644',
  } ->
  ini_setting { 'Enable Splunk LWF':
    path    => "${SPLUNKHOME}/etc/apps/SplunkLightForwarder/local/app.conf",
    section => 'install',
    setting => 'state',
    value   => $status,
    ensure  => present,
  }
}
