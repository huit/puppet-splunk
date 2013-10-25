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
# [index]
#   Default index to sent inputs to. Defaults to 'os'
#
# [localusers]
#
# [nagios_contacts]
#   Accepts a comma seperated list of contacts. Then enables and exports
#   Nagios Service checks for monitoring.
#
# [output_hash]
#   Optional hash of outputs that can be used instead of, or in addition to the
#   default group (tcpout) Useful for forwarding data to third party tools from
#   indexers.
#
#   output_hash   => { 'syslog:example_group' => {
#                        'server' => 'server.example.com:514' }
#                    }
#
# [port]
#   Splunk Default Input Port for indexers. Defaults to 9997. This sets both
#   The ports Monitored and the ports set in outputs.conf
#
# [proxyserver]
#   Define a proxy server for Splunk to use. Defaults to false.
#
# [purge]
#   purge => true
#   purge defaults to false, and only accepts a boolean as an argument.
#   purge purges all traces of splunk *without* a backup.
#
# [splunkadmin]
#
# [target_group]
#   Hash used to define splunk default groups and servers, valid configs are
#   { 'target group name' => 'server/ip' }
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
  $service_ensure  = $::splunk::params::service_ensure,
  $service_enable  = $::splunk::params::service_enable,
  $index           = $::splunk::params::index,
  $index_hash      = $::splunk::params::index_hash,
  $indexandforward = 'False',
  $localusers      = $::splunk::params::localusers,
  $nagios_contacts = $::splunk::params::nagios_contacts,
  $nagiosserver    = $::splunk::nagiosserver,
  $output_hash     = $::splunk::params::output_hash,
  $port            = $::splunk::params::port,
  $proxyserver     = $::splunk::params::proxyserver,
  $purge           = $::splunk::params::purge,
  $splunkadmin     = $::splunk::params::splunkadmin,
  $target_group    = $::splunk::params::target_group,
  $type            = $::splunk::params::type
) inherits splunk::params {

# Added the preseed hack after getting the idea from very cool
# TransGaming manifest
# at https://github.com/TransGaming/puppet/blob/master/splunk
#
  validate_string($type)
  case $type {
    'uf': {
      $pkgname    = 'splunkforwarder'
      $SPLUNKHOME = '/opt/splunkforwarder'
      $license    = undef
    }
    'hfw','lwf': {
      $SPLUNKHOME = '/opt/splunk'
      $pkgname    = 'splunk'
      $license    = 'puppet:///modules/splunk/noarch/opt/splunk/etc/splunk-forwarder.license'
    }
    default: {
      $SPLUNKHOME = '/opt/splunk'
      $pkgname    = 'splunk'
      $license    = undef
    }
  }


  if ( $purge ) {
    validate_bool($purge)
    class { 'splunk::purge': }

  } else {
    class { 'splunk::install':
      notify => Class['splunk::service'],
      before => Class['splunk::outputs'],
    }
    class { 'splunk::service': }

    case $type {
      'uf': {
        class { 'splunk::outputs': }
        class { 'splunk::config::mgmt_port': }
    }
      'lwf': {
        class { 'splunk::outputs': }
        class { 'splunk::config::lwf': }
        class { 'splunk::config::mgmt_port': }
        class { 'splunk::config::remove_uf': }
      }
      'hwf': {
        fail("Server type: $type is a feature that has not yet been implemented")
        #class { 'splunk::outputs': }
        #class { 'splunk::config::lwf': status => 'disabled' }
        #class { 'splunk::config::mgmt_port': }
        #class { 'splunk::config::hwf': }


        #class { 'splunk::app'                 : }
        #class { 'splunk::app::unix'           : }
        #class { 'splunk::app::ta-sos'         : }
        #class { 'splunk::app::collector'      : }
        #class { 'splunk::app::splunkforwarder': }

        # expect should be in the site/module
        #package { 'expect': }
      }
      'search': {
        fail("Server type: $type is a feature that has not yet been implemented")
        #class { 'splunk::config::lwf': status => 'disabled' }
        #class { 'splunk::config::mgmt_port': }
        #class { 'splunk::monitor::mgmt_port': }

        #class { 'splunk::server': }
        #class { 'splunk::app'          : }
        #class { 'splunk::app::unix'    : }
        #class { 'splunk::app::config'  : }
        #class { 'splunk::app::search'  : }
        #class { 'splunk::app::mom'     : }
        #class { 'splunk::app::maps'    : }
        #class { 'splunk::app::execview': }
        #class { 'splunk::app::nagios'  : }

        #package { 'python-redis': }
      }
      'indexer': {
        class { 'splunk::outputs': tcpout_disabled => 'True' }
        class { 'splunk::indexes': }

        class { 'splunk::config::lwf': status => 'disabled' }
        class { 'splunk::config::mgmt_port': disableDefaultPort => 'False' }
        class { 'splunk::config::remove_uf': }

        class { 'splunk::monitor::mgmt_port': }
        class { 'splunk::monitor::input_port': }

        #class { 'splunk::server'     : }
        #class { 'splunk::app'        : }
        #class { 'splunk::app::unix'  : }
        #class { 'splunk::app::index' : }
        #class { 'splunk::app::config': }
        #class { 'splunk::app::ta-sos': }
      }
      default: { fail("Server type: $type is not a supported Splunk type.") }
    }
  }
}
