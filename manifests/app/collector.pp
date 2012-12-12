class unsg_splunk::app::collector {
  $appname = collector
  file { '/etc/cron.d/collector':
    ensure  => 'present',
    content => template('unsg_splunk/etc/cron.d/collector.erb'),
  }

  package { 'splunk-collector':
    ensure  => installed,
    notify  => Service['splunk'],
    require => Package['splunk']
  }
}
