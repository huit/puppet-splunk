# splunk::limits should be called  to manage your splunk limits.conf
# by default outputs.conf will be placed in $splunkhome/etc/system/local/
# === Parameters
#
# [limit_hash]
#   Nested Hash used to define monitored limits. Sorry, I couldn't think of
#   a better way to do this :/
#   The format is:
#   { 'title' => { 'setting1' => 'value1' },
#                { 'setting2' => 'value2' }}
#
# class { 'splunk::limits':
#   limit_hash   => { 'search' => {
#                       max_searches_per_cpu => '1'},
#                     'thruput' => {
#                       maxKBps   => '10240',}
#  }
#
class splunk::limits (
  $path         = "${::splunk::splunkhome}/etc/system/local",
  $limit_hash   = { }
  ) {
  # Validate hash
  if ( $limit_hash ) {
    if !is_hash($limit_hash){
      fail("${limit_hash} is not a valid hash")
    }
  }
  $limit_title = keys($limit_hash)

  file { "${path}/limits.conf":
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0644',
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
    content => template('splunk/opt/splunk/etc/system/local/limits.conf.erb'),
  }
}
