class splunk::app::maps inherits splunk::app {
#  MOM Application
  $appname = maps
  file {
    "/opt/splunk/etc/apps/$appname":
      ensure  => directory,
      require => Package['splunk'],
  }

  vcsrepo { "/opt/splunk/etc/apps/$appname":
    ensure   => present,
    revision => "$::splunk::MAPSVERSION",
    provider => svn,
    source   => "https://svn.noc.harvard.edu/unsg/trunk/splunk/apps/$appname",
    #notify   => Service['splunk'],
    require  => [
      File   ["/opt/splunk/etc/apps/$appname"],
      Package['splunk'],
      Package['subversion']
    ]
  }
}
