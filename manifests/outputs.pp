# splunk::outputs should be called  to manage your splunk outputs.conf
# by default outputs.conf will be placed in $splunkhome/etc/system/local/
# === Parameters
#
# [output_hash]
#   Optional hash of outputs that can be used instead of, or in addition to the
#   default group (tcpout) Useful for forwarding data to third party tools from
#   indexers.
#
#   output_hash   => { 'syslog:example_group' => {
#                        'server' => 'server.example.com:514' }
#                    }
#
# [port]
#   port to send data to. Defaults to 9997
# [path]
#   Path to outputs.conf file to be managed
#
# [tcpout_disabled]
#   Enable global forwarding. Defaults to False, which *enables* Global fowarding.
#   On Indexers this will probably be set to "True" to disable forwarding of all inputs.
#
# [target_group]
#   Hash used to define splunk default groups and servers, valid configs are
#   { 'target group name' => 'server/ip' }
#
# For more info on outputs.conf
# http://docs.splunk.com/Documentation/Splunk/latest/admin/Outputsconf
class splunk::outputs (
  $indexandforward = $::splunk::indexandforward,
  $output_hash     = $::splunk::output_hash,
  $port            = $::splunk::port,
  $path            = "${::splunk::SPLUNKHOME}/etc/system/local",
  $tcpout_disabled = false,
  $target_group    = $::splunk::target_group
  ) {

  # Validate target group hash
  if !is_hash($target_group){
    fail('target_group is not a valid hash')
  }
  $groupkeys    = keys($target_group)
  $sorted       = sort($groupkeys)
  $defaultgroup = join($sorted, ",")

  # Validate outputs hash
  if ( $output_hash ) {
    if !is_hash($output_hash){
      fail("${output_hash} is not a valid hash")
    }
  }
  $output_title = keys($output_hash)



  file { "${path}/outputs.conf":
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0644',
    backup  => true,
    content => template('splunk/opt/splunk/etc/system/local/outputs.conf.erb'),
    notify  => Class['splunk::service']
  }
}
