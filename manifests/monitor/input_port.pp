# Monitor the Splunk TCP Input Port: Defaults to 9997
class splunk::monitor::input_port (
  $port            = $::splunk::port,
  $nagios_contacts = $::splunk::nagios_contacts
) {
  # Nagios Service Check
  if ( $nagios_contacts ) {
    @@nagios_service { "check_tcp${port}_${::hostname}":
      use                 => 'default-service',
      check_command       => "check_tcp!${port}",
      host_name           => $::fqdn,
      contacts            => $nagios_contacts,
      service_description => 'Splunk Input Port',
      notify              => Service['nagios'],
      tag                 => $::environment,
    }
  }
}
