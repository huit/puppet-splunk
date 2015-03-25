#Private Class configure universal forwarders
class splunk::config::uf (
  $splunkhome = $::splunk::splunkhome,
  $status  = 'enabled'
  ) {
  ini_setting { 'Disable Management Port':
    ensure  => present,
    path    => "${splunkhome}/etc/system/local/server.conf",
    section => 'httpServer',
    setting => 'disableDefaultPort',
    value   => 'True',
    require => Class['splunk::install'],
  }
}
