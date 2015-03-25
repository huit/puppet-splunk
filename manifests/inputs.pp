# splunk::inputs should be called  to manage your splunk inputs.conf
# by default outputs.conf will be placed in $splunkhome/etc/system/local/
# === Parameters
#
# [input_hash]
#   Nested Hash used to define monitored inputs. Sorry, I couldn't think of
#   a better way to do this :/
#   The format is:
#   { 'input title' => { 'setting' => 'value' } }
#
# class { 'splunk::inputs':
#   input_hash   => { 'script://./bin/sshdChecker.sh' => {
#                       disabled   => 'true',
#                       index      => 'os',
#                       interval   => '3600',
#                       source     => 'Unix:SSHDConfig',
#                       sourcetype => 'Unix:SSHDConfig'},
#                     'script://./bin/sshdChecker.sh2' => {
#                       disabled   => 'true2',
#                       index      => 'os2',
#                       interval   => '36002',
#                       source     => 'Unix:SSHDConfig2',
#                       sourcetype => 'Unix:SSHDConfig2'}
#                   }
#  }
#
class splunk::inputs (
  $path         = "${::splunk::splunkhome}/etc/system/local",
  $input_hash   = { }
  ) {
  # Validate hash
  if ( $input_hash ) {
    if !is_hash($input_hash){
      fail("${input_hash} is not a valid hash")
    }
  }
  $input_title = keys($input_hash)

  file { "${path}/inputs.conf":
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0644',
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
    content => template('splunk/opt/splunk/etc/system/local/inputs.conf.erb'),
  }
}
