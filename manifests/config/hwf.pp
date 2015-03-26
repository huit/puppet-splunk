#Private Class to enable/disable HWF
class splunk::config::hwf (
  $splunkhome = $::splunk::splunkhome,
  $status  = 'enabled'
  ) {
  file { "${splunkhome}/etc/apps/SplunkForwarder/local":
    ensure  => 'directory',
    owner   => 'splunk',
    group   => 'splunk',
    require => Class['splunk::install'],
  }
  file { "${splunkhome}/etc/apps/SplunkForwarder/local/app.conf":
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0644',
    require => Class['splunk::install'],
  } ->
  ini_setting { 'Enable Splunk HWF':
    ensure  => present,
    path    => "${splunkhome}/etc/apps/SplunkForwarder/local/app.conf",
    section => 'install',
    setting => 'state',
    value   => $status,
    require => Class['splunk::install'],
  }
}
