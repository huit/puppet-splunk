class unsg_splunk::app::splunkforwarder inherits unsg_splunk::app {

  $apppath = '/opt/splunk/etc/apps/SplunkForwarder/local'
  $SLFapppath = '/opt/splunk/etc/apps/SplunkLightForwarder/local'

  file {
    # First ensure that the pesky LF outputs file is gone
    'outputs.conf':
      ensure => 'absent',
      path   => '/opt/splunk/etc/apps/SplunkLightForwarder/local/outputs.conf';

    '/opt/splunk/etc/apps/SplunkForwarder/local': ensure => 'directory';

    # Next use the same erb template to generate our outputs.conf
    'heavy-outputs.conf':
      ensure  => 'present',
      path    => '/opt/splunk/etc/apps/SplunkForwarder/local/outputs.conf',
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0644',
      notify  => Service['splunk'],
      content => template("$::unsg_splunk::mod$SLFapppath/outputs.conf.erb");

    '/opt/splunk/etc/apps/SplunkForwarder/local/app.conf':
      content => "[install]\nstate = enabled\n",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0644',
      notify  => Service['splunk'],
      require => Package['splunk'];

    'transforms.conf':
      ensure  => 'present',
      path    => "$apppath/transforms.conf",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0644',
      notify  => Service['splunk'],
      content => template("$::unsg_splunk::mod$apppath/transforms.conf.erb");

    'props.conf':
      ensure  => 'present',
      path    => "$apppath/props.conf",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0644',
      notify  => Service['splunk'],
      content => template("$::unsg_splunk::mod$apppath/props.conf.erb");
  }
}
