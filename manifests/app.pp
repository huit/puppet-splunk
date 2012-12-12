class unsg_splunk::app (
  $vcsusr = $unsg_splunk::vcsusr,
  $vcspw  = $unsg_splunk::vcspw,
  $vcscmd = $unsg_splunk::params::vcscmd,
  $vcsurl = $unsg_splunk::params::vcsurl
){
  # Ensure service is running
  #TODO
  # rewrite this and get rid of svn for app deployment

  # disable light forwarding for all apps under splunk::app subclass
  file {
    '/opt/splunk/etc/apps/SplunkLightForwarder/local/app.conf':
      content => "[install]\nstate = disabled\n",
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0644',
      require => Package['splunk'];

    '/opt/splunk/etc/apps/SplunkLightForwarder':
      ensure  => directory,
      require => Package['splunk'];

    '/opt/splunk/etc/apps/SplunkLightForwarder/local':
      ensure  => directory,
      require => Package['splunk'];

    '/opt/splunk/etc/splunk-launch.conf':
      content => template('unsg_splunk/opt/splunk/etc/splunk-launch.conf.erb'),
  }

  # Get initial credential cache for the RO svn account so that
  # vcsrepo types can check out the repo
  exec { 'svn-credentials':
    command => "$vcscmd --password $vcspw $vcsurl > /dev/null 2>&1",
    path    => '/usr/bin:/usr/sbin:/bin:/opt/splunk/bin',
    cwd     => '/root',
    unless  => 'test -d /root/.subversion',
    before  => Class['packages'],
  }
}
