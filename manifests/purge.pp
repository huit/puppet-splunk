# USE WITH CAUTION
# splunk::purge takes no parameters and is dangerous!
# This class will PURGE all Splunk from your system. It's not really great
# To keep this in your node defintions as package for us requred purge, since
# we installed TA's with RPM's and so need package - purged to ensure depencies
# got removed
class splunk::purge () {
  service {
    'splunk':
      ensure     => stopped,
      enable     => false,
      hasrestart => true,
      pattern    => 'splunkd',
      before     => Package['splunk','splunkforwarder'],
  }
  package { ['splunk','splunkforwarder']:
    ensure   => purged,
  } ->

  file { '/etc/init.d/splunk':
    ensure => absent,
  }
  file { ['/opt/splunk','/opt/splunkforwarder']:
    ensure  => absent,
    force   => true,
    recurse => true,
  }
  notice("*** NOTICE Purge running on node: ${::fqdn} ***")
  notify {"*** NOTICE Purge running on node: ${::fqdn} ***":}
}
