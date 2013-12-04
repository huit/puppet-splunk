# Monitor the Splunk MGMT Port default 8089
class splunk::monitor::mgmt_port (
  $nagios_contacts = $::splunk::nagios_contacts
) {
  # Nagios Service Check
  if ( $nagios_contacts ) {
    @@nagios_service { "check_tcp8089_${::hostname}":
      use                 => 'default-service',
      check_command       => 'check_tcp!8089',
      host_name           => $::fqdn,
      contacts            => $nagios_contacts,
      service_description => 'Splunk Management Port',
      notify              => Service['nagios'],
      tag                 => $::environment,
    }
  }
}
