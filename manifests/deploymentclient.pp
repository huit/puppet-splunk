# splunk::deploymentclient
# Configure an agent as a deployment client.
# === Parameters
#
# [path]
#   Path to outputs.conf file to be managed
#
# [targeturi]
#   String used to define a Target Deployment Server.
#   targeturi is a *Required* Paramater if your going to use this class.
#   targeturi => 'deploymentserver.splunk.mycompany.com:8089'
#
class splunk::deploymentclient (
  $path              = "${::splunk::SPLUNKHOME}/etc/system/local",
  $targeturi         = undef
  ) {
  Class{ require => Class['splunk::install'] }

  # Validate string
  unless $targeturi {
    fail('"targeturi" has not been set, should be in the form of "deploymentserver.splunk.mycompany.com:8089"')
  }

  file { "${path}/deploymentclient.conf":
    ensure  => file,
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0644',
    content => template('splunk/opt/splunk/etc/system/local/deploymentclient.conf.erb'),
    notify  => Class['splunk::service']
  }
}
