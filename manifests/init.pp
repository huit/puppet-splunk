# == Class: splunk
#
# The splunk module will install Splunk agents in the form of a Light Weight 
# Fowarder, Heavy Forwarder, Universal Forwarder. It will also install servers
# for index, job and search configurations. 
#
# Please Note: This Module assumes you have the Splunk Packages in some sort of
# package repo.
#
# === Parameters
#
# Document parameters here.
#
# [purge]
#   purge => true
#   purge defaults to false, and only accepts a boolean as an argument.
#   purge purges all traces of splunk *without* a backup. 
#
# [type]
#   Install type. Defaults to Universal Forwarder valid inputs are:
#   uf      : Splunk Universal Forwarder
#   lwf     : Splunk Light Weight Forwarder
#   hwf     : Splunk Heavy Weight Forwarder
#   jobs    : Splunk Jobs Server - Search + Forwarding
#   search  : Splunk Search Head
#   indexer : Splunk Distribuited Index Server
#
# [target_group]
#   Hash used to define splunk default groups and servers, valid configs are
#   { 'target group name' => 'server/ip' }
#
# [splunkadmin]
#
# [localusers]
#
# [nagios_contacts]
#   Accepts a comma seperated list of contacts. Then enables and exports 
#   Nagios Service checks for monitoring. 
#
# [proxyserver]
#   Define a proxy server for Splunk to use. Defaults to false.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { splunk:
#    type => 'lwf',
#  }
#
# === Authors
#
# Tim Hartmann <tim_hartmann@harvard.edu>
#
# === Copyright
#
# Copyright 2013 Network Systems Team - Harvard University
#
class splunk (
  $ensurestat      = $::splunk::ensurestat,
  $enablestat      = $::splunk::enablestat,
  $license         = $::splunk::params::license,
  $localusers      = $::splunk::params::localusers,
  $nagios_contacts = $::splunk::params::nagios_contacts,
  $pkgname         = $::splunk::params::pkgname,
  $nagiosserver    = $::splunk::nagiosserver,
  $proxyserver     = $::splunk::params::proxyserver,
  $purge           = $::splunk::params::purge,
  $splunkadmin     = $::splunk::params::splunkadmin,
  $SPLUNKHOME      = $::splunk::params::SPLUNKHOME,
  $target_group    = $::splunk::params::target_group,
  $type            = $::splunk::params::type
) inherits splunk::params {

# Added the preseed hack after getting the idea from very cool
# TransGaming manifest
# at https://github.com/TransGaming/puppet/blob/master/splunk
#

  if ( $purge ) {
    validate_bool($purge)
    class { 'splunk::purge': }

  } else {
    class { 'splunk::install':
      notify => Class['splunk::service'],
    }
    class { 'splunk::service': }

    case $type {
      'uf': {
        class { 'splunk::outputs': } 
    }
      'lwf': {
        class { 'splunk::outputs': } 
        class { 'splunk::config::lwf': }
      }
      'hwf': {
        class { 'splunk::outputs': } 
        class { 'splunk::config::lwf': status => 'disabled' }
        class { 'splunk::config::hwf': }


        class { 'splunk::app'                 : }
        class { 'splunk::app::unix'           : }
        class { 'splunk::app::ta-sos'         : }
        class { 'splunk::app::collector'      : }
        class { 'splunk::app::splunkforwarder': }
        # expect should be in the site/module
        #package { 'expect': }
      }
      'search': {
        class { 'splunk::config::lwf': status => 'disabled' }

        class { 'splunk::server': }
        class { 'splunk::app'          : }
        class { 'splunk::app::unix'    : }
        class { 'splunk::app::config'  : }
        class { 'splunk::app::search'  : }
        class { 'splunk::app::mom'     : }
        class { 'splunk::app::maps'    : }
        class { 'splunk::app::execview': }
        class { 'splunk::app::nagios'  : }

        package { 'python-redis': }
      }
      'indexer': {
        class { 'splunk::config::lwf': status => 'disabled' }

        class { 'splunk::server'     : }
        class { 'splunk::app'        : }
        class { 'splunk::app::unix'  : }
        class { 'splunk::app::index' : }
        class { 'splunk::app::config': }
        class { 'splunk::app::ta-sos': }

        package { 'python-redis': }
      }
      default: { fail("Server type: $type is not a supported Splunk type.") }
    }
  }
}
