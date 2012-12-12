class unsg_splunk::app::mom inherits unsg_splunk::app {
#  MOM Application
  $appname = mom
  file {
    "/opt/splunk/etc/apps/$appname":
      ensure  => directory,
      require => Package['splunk'],
  }

  vcsrepo { "/opt/splunk/etc/apps/$appname":
    ensure   => present,
    revision => "$::unsg_splunk::MOMVERSION",
    provider => svn,
    source   => "https://svn.noc.harvard.edu/unsg/trunk/splunk/apps/$appname",
    #notify   => Service["splunk"],
    require  => [
      File   ["/opt/splunk/etc/apps/$appname"],
      Package['splunk'],
      Package['subversion']
      ]
  }
}
