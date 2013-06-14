# splunk::inputs should be called  to manage your splunk outputs.conf
# by default outputs.conf will be placed in $splunkhome/etc/system/local/
# === Parameters
#
# [script]
#   Hash used to define scripted inputs
#   { 'target group name' => 'server/ip' }
#
# [monitor]
#   Hash used to define monitored inputs
#
class splunk::inputs (
  $script  = undef,
  $monitor = undef
  ) {

  # Validate hash
  if ( $script ) {
    unless is_hash($script){
      fail("$script is not a valid hash")
    }
  if ( $monitor ) {
    unless is_hash($script){
      fail("$monitor is not a valid hash")
  }

  #file { "${path}/outputs.conf":
  #  ensure  => file,
  #  owner   => 'splunk',
  #  group   => 'splunk',
  #  mode    => '0644',
  #  content => template('splunk/opt/splunk/etc/system/local/outputs.conf.erb'),
  #  notify  => Class['splunk::service']
  #}
}
