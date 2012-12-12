class splunk::app::index (
  $nagios_contacts = $::splunk::params::nagios_contacts
) {
  File { ignore => '.svn' }
  file {
    # Create file to tell Networker to ignore the DB Directory
    '/opt/splunk/var/lib/': ensure => directory;
    '/opt/splunk/var/':     ensure => directory;

    '/opt/splunk/var/lib/.nsr':
      content => "+skip:splunk\n",
      mode    => '0400';
    '/mnt/.nsr':
      content => "+skip:splunk\n",
      mode    => '0400',
  }

  if $::splunk::app::index::nagios_contacts {
    # Nagios Service Check
    @@nagios_service { "check_tcp50514_${::hostname}":
      use                 => 'default-service',
      check_command       => 'check_tcp!50514',
      host_name           => $::fqdn,
      contacts            => $nagios_contacts,
      service_description => 'Splunk Input Port',
      notify              => Service['nagios'],
      tag                 => $::environment,
    }
  }
}
