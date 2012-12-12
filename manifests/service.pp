class unsg_splunk::service {
  service { 'splunk':
    ensure     => $::unsg_splunk::ensurestat,
    enable     => $::unsg_splunk::enablestat,
    hasrestart => true,
    hasstatus  => false,
    pattern    => 'splunkd',
  }
}
