#Private Class to enable/disable the Splunk Managment Port
class splunk::config::mgmt_port (
  $disableDefaultPort = 'True',
  $SPLUNKHOME         = $::splunk::SPLUNKHOME
  ) {
  ini_setting { 'Configure Management Port':
    ensure  => present,
    path    => "${SPLUNKHOME}/etc/system/local/server.conf",
    section => 'httpServer',
    setting => 'disableDefaultPort',
    value   => $disableDefaultPort,
    require => Class['splunk::install'],
  }
}
