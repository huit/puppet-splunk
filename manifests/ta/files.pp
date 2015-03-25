# == Defined Type: splunk::ta::files
# splunk::ta::files will install a TA from the file bucket from the
# Splunk Module, or more correctly from the site/ Splunk Module
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
#
# splunk::ta::files { 'Splunk_TA_nix': }
define splunk::ta::files (
  $configfile = "puppet:///modules/splunk/ta/${title}",
  $index      = $::splunk::index,
  $inputfile  = "splunk/${title}/inputs.conf.erb",
  $status     = 'enabled',
  $splunkhome = $::splunk::splunkhome
) {
  File { ignore => '*.py[oc]' }

  file { "${splunkhome}/etc/apps/${title}":
    ensure  => present,
    owner   => 'splunk',
    group   => 'splunk',
    recurse => true,
    purge   => false,
    source  => $configfile,
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
  } ->
  file { "${splunkhome}/etc/apps/${title}/local":
    ensure => directory,
  } ->
  file { "${splunkhome}/etc/apps/${title}/local/app.conf":
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0644',
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
  } ->
  file { "${splunkhome}/etc/apps/${title}/local/inputs.conf":
    ensure  => present,
    owner   => 'splunk',
    group   => 'splunk',
    content => template($inputfile),
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
  } ->
  ini_setting { "Enable Splunk ${title} TA":
    ensure  => present,
    path    => "${splunkhome}/etc/apps/${title}/local/app.conf",
    section => 'install',
    setting => 'state',
    value   => $status,
    require => Class['splunk::install'],
    notify  => Class['splunk::service'],
  }
}
