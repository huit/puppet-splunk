class unsg_splunk::packages {
  package { 'splunk':
    ensure   => installed,
    provider => yum,                                                                                                       
    notify   => Exec['preseed-server.conf'],
  }
}
