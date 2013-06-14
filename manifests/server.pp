class splunk::server (
) {
  $pyversion = $::lsbmajdistrelease ? {
    5 => '/usr/lib/python2.4',
    6 => '/usr/lib/python2.6',
  } 
  file { '/usr/lib/python': ensure => "$pyversion" }
  
}   
