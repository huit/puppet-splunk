#Private Class to enable/disable HWF
class splunk::config::hwf (
  $SPLUNKHOME = $::splunk::SPLUNKHOME,
  $status  = 'enabled'
  ) {
  file { "${SPLUNKHOME}/etc/apps/SplunkForwarder/local":
    ensure => 'directory',
    owner  => 'splunk',
    group  => 'splunk',
  }
  file { "${SPLUNKHOME}/etc/apps/SplunkForwarder/local/app.conf":
    ensure => file,
    owner  => 'splunk',
    group  => 'splunk',
    mode   => '0644',
  } ->
  ini_setting { 'Enable Splunk HWF':
    path    => "${SPLUNKHOME}/etc/apps/SplunkForwarder/local/app.conf",
    section => 'install',
    setting => 'state',
    value   => $status,
    ensure  => present,
  }
}
