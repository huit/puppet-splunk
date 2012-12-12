class unsg_splunk::server (
  $mb  = $::unsg_splunk::mb,
  $sms = $::unsg_splunk::sms
) {
  $pyversion = $::lsbmajdistrelease ? {
    5 => '/usr/lib/python2.4',
    6 => '/usr/lib/python2.6',
  } 
  file { '/usr/lib/python': ensure => "$pyversion" }
  package { 'python-redis': }
  
  # Nagios Service Check
  @@nagios_service { "check_tcp8089_$::hostname":
    use                 => 'default-service',
    check_command       => 'check_tcp!8089',
    host_name           => $::fqdn,
    contacts            => "$mb-email,$sms",
    service_description => 'Splunk Management Port',
    notify              => Service['nagios'],
    tag                 => $::environment,
  } 
}   
