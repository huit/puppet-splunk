class { 'splunk':
  port         => '50514',
  target_group => { 'name' => 'splunkindex-60ox.noc.harvard.edu' },
}
splunk::ta::files { 'Splunk_TA_nix': }
