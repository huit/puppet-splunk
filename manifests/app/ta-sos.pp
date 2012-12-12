class unsg_splunk::app::ta-sos inherits unsg_splunk::app {
  $appname = ta-sos

  package { 'splunk-TA-sos':
    ensure  => installed,
    notify  => Service['splunk'],
    require => Package['splunk']
  }
}
