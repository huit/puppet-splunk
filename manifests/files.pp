class unsg_splunk::files (
  $mod         = $::unsg_splunk::mod,
  $splunkadmin = $::unsg_splunk::splunkadmin,
  $type        = $::unsg_splunk::type
  ) {

  if ( $type == 'lwf' ) {
    $license = "puppet:///modules/$mod/noarch/opt/splunk/etc/splunk-forwarder.license"
  } else {
    $license = undef
  }

  exec { 'preseed-server.conf':
    command     => "/bin/echo -e \"[general]\nserverName = $::fqdn\" >/opt/splunk/etc/system/local/server.conf",
    refreshonly => 'true',
    notify      => Service['splunk'],
  } 
  augeas { 'local/server.conf':
    context =>  '/files/opt/splunk/etc/system/local/server.conf',
    changes => [
      "set general/serverName $::fqdn",
      'set sslConfig/supportSSLV3Only True',
    ],
    require => File['splunk.aug'],
  } 

  file {
    # Splunk lens - based on the Puppet lens
    'splunk.aug':
      ensure => present,
      name   => '/usr/share/augeas/lenses/dist/splunk.aug',
      mode   => '0644',
      source => "puppet:///modules/$mod/noarch/usr/share/augeas/lenses/dist/splunk.aug";
      
    '/opt/splunk/etc/splunk.license':
      ensure  => present,
      mode    => '0644',
      owner   => 'splunk',
      group   => 'splunk',
      backup  => true,
      source  => $license;
      
    '/etc/init.d/splunk':
      ensure  => present,
      mode    => '0700',
      owner   => 'root',
      group   => 'root',
      source  => "puppet:///modules/$mod/noarch/etc/init.d/splunk";
      
    '/opt/splunk/etc/passwd':
      ensure   => present,
      mode     => '0600',
      owner    => 'root',
      group    => 'root',
      backup   => true,
      content  => template("$mod/opt/splunk/etc/passwd.erb");
      
    # recursively copy the contents of the auth dir
    '/opt/splunk/etc/auth':
      mode    => '0600',
      owner   => 'splunk',
      group   => 'splunk',
      recurse => true,
      purge   => false,
      source  => "puppet:///modules/$mod/noarch/opt/splunk/etc/auth",
  }
}
