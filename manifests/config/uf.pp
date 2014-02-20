#Private Class configure universal forwarders
class splunk::config::uf (
  $SPLUNKHOME = $::splunk::SPLUNKHOME,
  $status  = 'enabled'
  ) {
  ini_setting { 'Disable Management Port':
    ensure  => present,
    path    => "${SPLUNKHOME}/etc/system/local/server.conf",
    section => 'httpServer',
    setting => 'disableDefaultPort',
    value   => 'True',
    require => Class['splunk::install'],
  }
}
