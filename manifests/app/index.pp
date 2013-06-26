class splunk::app::index (
) {
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
}
