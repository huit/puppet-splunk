class { 'splunk':
  type         => 'lwf',
}
splunk::ta::files { 'Splunk_TA_nix': }
class { 'splunk::inputs': }
#class { 'splunk::inputs': 
#  input_hash   => { 'script://./bin/sshdChecker.sh' => {
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
#}
