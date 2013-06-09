# Class: splunk
#
# This module manages Splunk forwarders, Light Forwarders,
# Indexers and Search heads
#
# Parameters:
# This Module has "Maintenance Mode"
#
# Actions:
#
# Requires:
#
# Sample Usage: adding "mode=maintenance" as a parameter will stop this module
# Create Light Fwd   : class { 'splunk' type => 'lwf' }
# Create Indexer     : class { 'splunk' type => 'indexer' }
# Create Search Head : class { 'splunk' type => 'search' }
# Create Heavy Fwd   : class { 'splunk' type => 'collector' }
#
# [Remember: No empty lines between comments and class definition]
class splunk (
  $ensurestat      = $::splunk::ensurestat,
  $enablestat      = $::splunk::enablestat,
  $license         = $::splunk::params::license,
  $localusers      = $::splunk::params::localusers,
  $nagios_contacts = $::splunk::params::nagios_contacts,
  $pkgname         = $::splunk::params::pkgname,
  $nagiosserver    = $::splunk::nagiosserver,
  $proxyserver     = $::splunk::params::proxyserver,
  $purge           = undef,
  $splunkadmin     = $::splunk::params::splunkadmin,
  $SPLUNKHOME      = $::splunk::params::SPLUNKHOME,
  $type            = $::splunk::params::type,
) inherits splunk::params {

# Added the preseed hack after getting the idea from very cool
# TransGaming manifest
# at https://github.com/TransGaming/puppet/blob/master/splunk
#

  if ( $purge ) {
    class { 'splunk::purge': }

  } else {
    class { 'splunk::install': }
  }

  case $type {
    'uf': {
  }
    'lwf': {
      class { 'splunk::app::unix': }
      class { 'splunk::forwarder': }
    }
    'search': {
      class { 'splunk::server': }
      class { 'splunk::app'          : }
      class { 'splunk::app::unix'    : }
      class { 'splunk::app::config'  : }
      class { 'splunk::app::search'  : }
      class { 'splunk::app::mom'     : }
      class { 'splunk::app::maps'    : }
      class { 'splunk::app::execview': }
      class { 'splunk::app::nagios'  : }
    }
    'indexer': {
      class { 'splunk::server'     : }
      class { 'splunk::app'        : }
      class { 'splunk::app::unix'  : }
      class { 'splunk::app::index' : }
      class { 'splunk::app::config': }
      class { 'splunk::app::ta-sos': }
    }
    'collector': {
      class { 'splunk::app'                 : }
      class { 'splunk::app::unix'           : }
      class { 'splunk::app::ta-sos'         : }
      class { 'splunk::app::collector'      : }
      class { 'splunk::app::splunkforwarder': }
      package { 'expect': }
    }
  }
}
