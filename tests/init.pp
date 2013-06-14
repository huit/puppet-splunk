class { 'splunk':
  port         => '50514',
  target_group => { 'name' => '1.2.3.4' },
}
