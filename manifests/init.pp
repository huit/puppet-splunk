# Class: unsg_splunk
#
# This module manages unsg_splunk forwarders, Light Forwarders,
# Indexers and Search heads
#
# Parameters:
# This Module has "Maintence Mode"
#
# Actions:
#
# Requires:
#
# Sample Usage: adding "mode=maintence" as a paramater will stop this module
#
# [Remember: No empty lines between comments and class definition]
class unsg_splunk (
  $mod          = unsg_splunk,
  $type         = $::unsg_splunk::params::type,
  $splunkadmin  = $::unsg_splunk::params::splunkadmin,
  $localusers   = $::unsg_splunk::params::localusers,
  $proxyserver  = $::unsg_splunk::params::proxyserver,
  $mb           = $::unsg_common::mb,
  $sms          = $::unsg_common::sms,
  $nagiosserver = $::unsg_splunk::nagiosserver,
  $ensurestat   = $::unsg_splunk::ensurestat,
  $enablestat   = $::unsg_splunk::enablestat,
  $vcsusr       = $::unsg_splunk::params::vcsusr,
  $vcspw        = $::unsg_splunk::params::vcspw
) inherits unsg_splunk::params {
File {ignore => '.svn', require => Package['splunk'] }

# Added the preseed hack after getting the idea from very cool
# TransGaming manifest
# at https://github.com/TransGaming/puppet/blob/master/splunk
#
# Defined Variables for use in SVN Application Checkouts
####
$CONFIGVERSION = '229'
$COLLECTORVERSION = '162'
$MOMVERSION = '217'
$MAPSVERSION = '114'
####

  class { 'unsg_splunk::packages': } ->
  class { 'unsg_splunk::files': }    ->
  class { 'unsg_splunk::service': }

  case $type {
    'lwf': {
      class { 'unsg_splunk::app::unix': }
      class { 'unsg_splunk::forwarder': }
    }
    'search': {
      class { 'unsg_splunk::server': }
      class { 'unsg_splunk::app'          : }
      class { 'unsg_splunk::app::unix'    : }
      class { 'unsg_splunk::app::config'  : }
      class { 'unsg_splunk::app::search'  : }
      class { 'unsg_splunk::app::mom'     : }
      class { 'unsg_splunk::app::maps'    : }
      class { 'unsg_splunk::app::execview': }
      class { 'unsg_splunk::app::nagios'  : }
    }
    'indexer': {
      class { 'unsg_splunk::server'     : }
      class { 'unsg_splunk::app'        : }
      class { 'unsg_splunk::app::unix'  : }
      class { 'unsg_splunk::app::index' : }
      class { 'unsg_splunk::app::config': }
      class { 'unsg_splunk::app::ta-sos': }
    }
    'collector': {
      class { 'unsg_splunk::app'                 : }
      class { 'unsg_splunk::app::unix'           : }
      class { 'unsg_splunk::app::ta-sos'         : }
      class { 'unsg_splunk::app::collector'      : }
      class { 'unsg_splunk::app::splunkforwarder': }
      package { 'expect': }
    }
  }
}
