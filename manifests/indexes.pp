# splunk::indexes should be called  to manage your splunk indexes.conf
# by default indexes.conf will be placed in $splunkhome/etc/system/local/
# === Parameters
#
# [input_hash]
#   Nested Hash used to define monitored indexes. Sorry, I couldn't think of
#   a better way to do this :/
#   The format is:
#   { 'input title' => { 'setting' => 'value' } }
#
# class { 'splunk::indexes': 
#   input_hash   => { 'dns' => {
#                       'homePath'               => '$SPLUNK_DB/dns/db',
#                       'coldPath'               => '/mnt/splunk/dns/colddb',
#                       'thawedPath'             => '$SPLUNK_DB/dns/thaweddb',
#                       'homePath.maxDataSizeMB' => '102400',
#                       'frozenTimePeriodInSecs' => '3888000' },
#                   }
#  }
#
class splunk::indexes (
  $path         = "${::splunk::SPLUNKHOME}/etc/system/local",
  $input_hash   = $::splunk::index_hash
  ) {
  # Validate hash
  if ( $input_hash ) {
    unless is_hash($input_hash){
      fail("$input_hash is not a valid hash")
    }
  }
  $input_title = keys($input_hash)

  file { "${path}/indexes.conf":
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0644',
    backup  => true,
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
    content => template('splunk/opt/splunk/etc/system/local/indexes.conf.erb'),
  }
}
