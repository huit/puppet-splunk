class splunk::app::splunkforwarder inherits splunk::app {

  $apppath = '/opt/splunk/etc/apps/SplunkForwarder/local'
  $SLFapppath = '/opt/splunk/etc/apps/SplunkLightForwarder/local'

  file {
  # Both are now in etc/system/local
    # First ensure that the pesky LF outputs file is gone
    #'outputs.conf':
    #  ensure => 'absent',
    #  path   => '/opt/splunk/etc/apps/SplunkLightForwarder/local/outputs.conf';

    #'/opt/splunk/etc/apps/SplunkForwarder/local': ensure => 'directory';

  # Not needed - we can just pass a different array to the HWF
    # Next use the same erb template to generate our outputs.conf
    #'heavy-outputs.conf':
    #  ensure  => 'present',
    #  path    => '/opt/splunk/etc/apps/SplunkForwarder/local/outputs.conf',
    #  owner   => 'splunk',
    #  group   => 'splunk',
    #  mode    => '0644',
    #  notify  => Service['splunk'],
    #  content => template("$::splunk::mod$SLFapppath/outputs.conf.erb");


  # hmmm maybe an enable / diable flag for LWF?
    #'/opt/splunk/etc/apps/SplunkForwarder/local/app.conf':
    #  content => "[install]\nstate = enabled\n",
    #  owner   => 'splunk',
    #  group   => 'splunk',
    #  mode    => '0644',
    #  notify  => Service['splunk'],
    #  require => Package['splunk'];

    'transforms.conf':
      ensure  => 'present',
      path    => "$apppath/transforms.conf",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0644',
      notify  => Service['splunk'],
      content => template("$::splunk::mod$apppath/transforms.conf.erb");

    'props.conf':
      ensure  => 'present',
      path    => "$apppath/props.conf",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0644',
      notify  => Service['splunk'],
      content => template("$::splunk::mod$apppath/props.conf.erb");
  }
}
