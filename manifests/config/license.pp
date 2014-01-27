#Private Class to Configure Splunk License Slave
class splunk::config::license (
  $server     = 'splunklicense.example.com',
  $SPLUNKHOME = $::splunk::SPLUNKHOME
  ) {
  ini_setting { 'Configure Splunk License':
    ensure  => present,
    path    => "${SPLUNKHOME}/etc/system/local/server.conf",
    section => 'license',
    setting => 'master_uri',
    value   => "https://${server}:8089",
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
  }
}
