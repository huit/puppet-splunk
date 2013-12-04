# == Defined Type: splunk::ta::package
# splunk::ta::package will install a TA from a Package (RPM) built from the
# Splunk Module
#
# This Definition assumes the package name will be splunk-<APP NAME>. For
# example, And that <APP NAME> will match the the name on Splunk Base. So
# the Splunk for UNIX App, which downloads as "unix.spl" would be an RPM
# called "splunk-unix.x.x.rpm"
#
# NOTE: In some cases, like the Splunk for Unix APP and UNIX TA
# You may want to use the same input.conf file for both, in wich case you
# should pass the inputfile parameter.
# http://docs.splunk.com/Documentation/UnixApp/4.7/User/InstalltheSplunkTechnicalAddonforUnixandLinux
#
# === Parameters
#
# Document parameters here.
#
# [configfile]
#   Path to extracted Splunk TA on the Puppet Master.
#
# [status]
#   App Status. Defaults to enabled
#
# [inputfile]
#   Location of the inputfile template to use for the install TA/APP
#   the format of the input should be <modulename>/<path/to/template.erb
#
# === Examples
# In this example the the splunk-unix package will get installed
# and the input file used will be the default input file for the
# Splunk for Unix TA.
#
# splunk::ta::package { 'unix':
#   inputfile => 'splunk/Splunk_TA_nix/inputs.conf.erb',
# }
#
define splunk::ta::package (
  $index      = $::splunk::index,
  $inputfile  = "splunk/${title}/inputs.conf.erb",
  $status     = 'enabled',
  $SPLUNKHOME = $::splunk::SPLUNKHOME
) {
  package { "splunk-${title}":
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
  } ->
  file { "${SPLUNKHOME}/etc/apps/${title}/local":
    ensure => directory,
  } ->
  file { "${SPLUNKHOME}/etc/apps/${title}/local/app.conf":
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0644',
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
  } ->
  file { "${SPLUNKHOME}/etc/apps/${title}/local/inputs.conf":
    ensure  => present,
    owner   => 'splunk',
    group   => 'splunk',
    content => template($inputfile),
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
  } ->
  ini_setting { "Enable Splunk ${title} TA":
    ensure  => present,
    path    => "${SPLUNKHOME}/etc/apps/${title}/local/app.conf",
    section => 'install',
    setting => 'state',
    value   => $status,
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
  }
}
