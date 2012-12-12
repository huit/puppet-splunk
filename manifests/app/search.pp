class splunk::app::search inherits splunk::app {
  $apppath = '/opt/splunk/etc/apps/search/local'
  file {
    '/opt/splunk/etc/system/local/web.conf':
      content => template("$::splunk::mod/opt/splunk/etc/system/local/web.conf.erb"),
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0644',
      backup  => 'true',
      notify  => Service['splunk'],
      require => Package['splunk'];

    '/opt/splunk/etc/apps/search/local/server.conf':
      content => template("$::splunk::mod$apppath/server.conf.erb"),
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0644',
      backup  => 'true',
      notify  => Service['splunk'],
      require => Package['splunk'];

    '/opt/splunk/etc/apps/search/local':
      ensure => directory;
  }
}
