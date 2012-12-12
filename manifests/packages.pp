class splunk::packages {
  package { 'splunk':
    ensure   => installed,
    provider => yum,                                                                                                       
    notify   => Exec['preseed-server.conf'],
  }
}
