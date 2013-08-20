class splunk::service {
  service {
    'splunk':
      ensure     => $::splunk::service_ensure,
      enable     => $::splunk::service_enable,
      hasrestart => true,
      pattern    => 'splunkd',
  }

}
