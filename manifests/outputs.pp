# splunk::outputs should be called  to manage your splunk outputs.conf
# by default outputs.conf will be placed in $splunkhome/etc/system/local/
# === Parameters
#
# [port]
#   port to send data to. Defaults to 9997
# [path]
#   Path to outputs.conf file to be managed
# [target_group]
#   Hash used to define splunk default groups and servers, valid configs are
#   { 'target group name' => 'server/ip' }
#
# For more info on outputs.conf
# http://docs.splunk.com/Documentation/Splunk/latest/admin/Outputsconf
class splunk::outputs (
  $port         = $::splunk::port,
  $path         = "${::splunk::SPLUNKHOME}/etc/system/local",
  $target_group = $::splunk::target_group
  ) {
  Class { require => Class['splunk::install'] }

  # Validate hash
  unless is_hash($target_group){
    fail("target_group is not a valid hash")
  }
  $groupkeys = keys($target_group)
  $defaultgroup = join($groupkeys, ",")

  file { "${path}/outputs.conf":
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0644',
    content => template('splunk/opt/splunk/etc/system/local/outputs.conf.erb'),
    notify  => Class['splunk::service']
  }
}
