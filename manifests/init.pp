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
#
# [Remember: No empty lines between comments and class definition]
class splunk (
  $mod          = splunk,
  $type         = $::splunk::params::type,
  $splunkadmin  = $::splunk::params::splunkadmin,
  $localusers   = $::splunk::params::localusers,
  $proxyserver  = $::splunk::params::proxyserver,
  $mb           = $::unsg_common::mb,
  $sms          = $::unsg_common::sms,
  $nagiosserver = $::splunk::nagiosserver,
  $ensurestat   = $::splunk::ensurestat,
  $enablestat   = $::splunk::enablestat,
  $vcsusr       = $::splunk::params::vcsusr,
  $vcspw        = $::splunk::params::vcspw
) inherits splunk::params {
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

  class { 'splunk::packages': } ->
  class { 'splunk::files': }    ->
  class { 'splunk::service': }

  case $type {
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
