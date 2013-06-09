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
  $port         = '9997',
  $path         = '/tmp',
  $target_group = { example1 => 'server1.example.com',
                    example2 => 'server2.example.com' }
  ) {

  # Validate hash
  unless is_hash($target_group){
    fail("target_group is not a valid hash")
  }
  $groupkeys = keys($target_group)
  $defaultgroup = join($groupkeys, ",")

  file { "${path}/outputs.conf":
    ensure => file,
    owner  => 'splunk',
    group  => 'splunk',
    mode   => '0644',
  }
  ini_setting { "outputs.conf - defaultGroup":
    path    => "$path/outputs.conf",
    section => 'tcpout',
    setting => 'defaultGroup',
    value   => $defaultgroup,
    ensure  => present,
  }
  ini_setting { "outputs.conf - group status":
    path    => "$path/outputs.conf",
    section => 'tcpout',
    setting => 'disabled',
    value   => 'false',
    ensure  => present,
  }

  splunk::outputs::tcpout { $groupkeys: }
}
define splunk::outputs::tcpout (
  $path         = $::splunk::outputs::path,
  $port         = $::splunk::outputs::port,
  $target_group = $::splunk::outputs::target_group
) {
  $server = $target_group[$title]
  ini_setting { "$title":
    path    => "${path}/outputs.conf",
    section => "tcpout:${title}",
    setting => 'server',
    value   => "${server}:${port}",
    ensure  => present,
  }
}
