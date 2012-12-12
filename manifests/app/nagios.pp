class unsg_splunk::app::nagios {
  File { notify => Service['splunk'], require => Package['splunk-nagios'] }

  $apppath = '/opt/splunk/etc/apps/SplunkForNagios'

  package {'splunk-nagios':
    ensure   => installed,
    provider => yum,
    notify   => Service['splunk'],
    require  => Package['splunk']
  }
  file {
    'livehostsdownstatus.py':
      ensure  => 'present',
      path    => "$apppath/bin/livehostsdownstatus.py",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0755',
      content => template("$::unsg_splunk::mod$apppath/bin/livehostsdownstatus.py.erb");

    'livehostsupstatus.py':
      ensure  => 'present',
      path    => "$apppath/bin/livehostsupstatus.py",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0755',
      content => template("$::unsg_splunk::mod$apppath/bin/livehostsupstatus.py.erb");

    'liveservicestate.py':
      ensure  => 'present',
      path    => "$apppath/bin/liveservicestate.py",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0755',
      content => template("$::unsg_splunk::mod$apppath/bin/liveservicestate.py.erb");

    'liveserviceokstatus.py':
      ensure  => 'present',
      path    => "$apppath/bin/liveserviceokstatus.py",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0755',
      content => template("$::unsg_splunk::mod$apppath/bin/liveserviceokstatus.py.erb");

    'liveservicecriticalstatus.py':
      ensure  => 'present',
      path    => "$apppath/bin/liveservicecriticalstatus.py",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0755',
      content => template("$::unsg_splunk::mod$apppath/bin/liveservicecriticalstatus.py.erb");

    'liveserviceunknownstatus.py':
      ensure  => 'present',
      path    => "$apppath/bin/liveserviceunknownstatus.py",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0755',
      content => template("$::unsg_splunk::mod$apppath/bin/liveserviceunknownstatus.py.erb");

    'livehostsunreachablestatus.py':
      ensure  => 'present',
      path    => "$apppath/bin/livehostsunreachablestatus.py",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0755',
      content => template("$::unsg_splunk::mod$apppath/bin/livehostsunreachablestatus.py.erb");

    'liveservicewarningstatus.py':
      ensure  => 'present',
      path    => "$apppath/bin/liveservicewarningstatus.py",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0755',
      content => template("$::unsg_splunk::mod$apppath/bin/liveservicewarningstatus.py.erb");

    'splunk-nagios-hosts.py':
      ensure  => 'present',
      path    => "$apppath/bin/splunk-nagios-hosts.py",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0755',
      content => template("$::unsg_splunk::mod$apppath/bin/splunk-nagios-hosts.py.erb");

    'splunk-nagios-hostgroupmembers.sh':
      ensure  => 'present',
      path    => "$apppath/bin/splunk-nagios-hostgroupmembers.sh",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0755',
      content => template("$::unsg_splunk::mod$apppath/bin/splunk-nagios-hostgroupmembers.sh.erb");

    'splunk-nagios-servicegroupmembers.sh':
      ensure  => 'present',
      path    => "$apppath/bin/splunk-nagios-servicegroupmembers.sh",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0755',
      content => template("$::unsg_splunk::mod$apppath/bin/splunk-nagios-servicegroupmembers.sh.erb"),
  }
}
