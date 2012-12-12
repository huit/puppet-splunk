class splunk::app::collector {
  $appname = collector
  file { '/etc/cron.d/collector':
    ensure  => 'present',
    content => template('splunk/etc/cron.d/collector.erb'),
  }

  package { 'splunk-collector':
    ensure  => installed,
    notify  => Service['splunk'],
    require => Package['splunk']
  }
}
