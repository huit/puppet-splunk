# splunk::inputs::create allows you to register new inputs.
#
# === Parameters
#- The resource name is used as the input title in inputs.conf
#- $content should be a hash containing what you want to apply to the input
#- $order is optional, it allows you to set input position in the resulting file
#- $path functions the same it does in splunk::inputs.
#
# === Example
#- Puppet code
# ::splunk::inputs::create {'script://./bin/sshdChecker.sh':
#   $content => {
#     disabled   => 'true',
#     index      => 'os',
#     interval   => '3600',
#     source     => 'Unix:SSHDConfig',
#     sourcetype => 'Unix:SSHDConfig'
#   }
# }
#
#- Resulting input config
# [script://./bin/sshdChecker.sh]
#   disabled = true
#   index = os
#   interval = 3600
#   source = Unix:SSHDConfig
#   sourcetype = Unix:SSHDConfig
#
define splunk::inputs::create(
  $content,
  $order   = '10',
  $path    = "${::splunk::splunkhome}/etc/system/local"
) {
  # Validate hash
  if !is_hash($content){
    fail("${content} is not a valid hash")
  }

  concat::fragment {"Inputs ${name}":
    target  => "${path}/inputs.conf",
    order   => $order,
    content => template('splunk/opt/splunk/etc/system/local/inputs_create.erb'),
    notify  => Class['splunk::service']
  }
}