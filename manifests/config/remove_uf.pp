# Internal class used to remove Universal Forwarders in case a node changes types.
# i.e, a node is build with the defaults and needs to be switched to a Search Head.
class splunk::config::remove_uf () {
  package { 'splunkforwarder':
    ensure => absent,
    notify => Class['splunk::service'],
  } ->

  file { '/opt/splunkforwarder':
    ensure  => absent,
    force   => true,
    recurse => true,
  }
}
