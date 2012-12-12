class splunk::service {
  service { 'splunk':
    ensure     => $::splunk::ensurestat,
    enable     => $::splunk::enablestat,
    hasrestart => true,
    hasstatus  => false,
    pattern    => 'splunkd',
  }
}
