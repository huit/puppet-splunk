# splunk::inputs should be called  to manage your splunk inputs.conf
# by default outputs.conf will be placed in $splunkhome/etc/system/local/
# === Parameters
#
# [script]
#   { 'target group name' => 'server/ip' }
#
# [monitor]
#   Hash used to define monitored inputs
#
define splunk::inputs (
  $type,
  $disabled   = 'false',
  $input      = undef,
  $index      = $::splunk::index,
  $source     = undef,
  $sourcetype = undef,

  ) {

#nameof-input = key => value, key => value 

#[script://./bin/sshdChecker.sh]
#disabled = true
#index = os
#interval = 3600
#source = Unix:SSHDConfig
#sourcetype = Unix:SSHDConfig


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
