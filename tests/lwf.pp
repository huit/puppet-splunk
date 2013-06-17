class { 'splunk':
  index        => 'ns-os',
  type         => 'lwf',
  port         => '50514',
  target_group => { 'name' => 'splunkindex-60ox.noc.harvard.edu' },
}
class { 'splunk::inputs': }
splunk::ta::files { 'Splunk_TA_nix': }
