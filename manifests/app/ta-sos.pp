class splunk::app::ta-sos inherits splunk::app {
  $appname = ta-sos

  package { 'splunk-TA-sos':
    ensure  => installed,
    notify  => Service['splunk'],
    require => Package['splunk']
  }
}
