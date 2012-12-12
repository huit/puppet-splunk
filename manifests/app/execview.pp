class unsg_splunk::app::execview {

  $apppath     = '/opt/splunk/etc/apps/exec_view'
  $redisServer = 'splunkcollector1'

  case $hostname {
    /-10wa/: { $collector = "$redisServer-10wa.noc.harvard.edu" }
    /-60ox/: { $collector = "$redisServer-60ox.noc.harvard.edu" }
  }

  package { 'splunk-execview':
    ensure   => 'latest',
    provider => 'yum',
    notify   => Service['splunk'],
    require  => Package['splunk']
  }
  file {
    # Start App
    '/opt/splunk/etc/apps/exec_view/local':
      ensure  => 'directory',
      owner   => 'splunk',
      group   => 'splunk',
      require => Package['splunk', 'splunk-execview'];

    '/opt/splunk/etc/apps/exec_view/lookups/mac2huid.csv':
      require => Package['splunk', 'splunk-execview'],
      source => "puppet:///files/scripts/splunk/lookups/mac2huid.csv";

    '/opt/splunk/etc/apps/exec_view/lookups/rhds_status.csv':
      require => Package['splunk', 'splunk-execview'],
      source => "puppet:///files/scripts/splunk/lookups/rhds_status.csv";

    '/opt/splunk/etc/apps/exec_view/lookups/dmca_lookup.csv':
      require => Package['splunk', 'splunk-execview'],
      source => "puppet:///files/scripts/splunk/lookups/dmca_lookup.csv";

    '/opt/splunk/etc/apps/exec_view/lookups/mac_tracking.csv':
      require => Package['splunk', 'splunk-execview'],
      source => "puppet:///files/scripts/splunk/lookups/mac_tracking.csv";

    'huis.py':
      ensure  => 'present',
      path    => "$apppath/bin/huis.py",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0755',
      notify  => Service['splunk'],
      content => template("$::unsg_splunk::mod$apppath/bin/huis.py.erb"),
  }
}
