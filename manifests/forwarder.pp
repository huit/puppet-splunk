class splunk::forwarder ( $mod = $::splunk::mod ){
#
# In the forwarder class you can manage both the SplunkLightForwarder
# app and the unix app by manipulating the files on the puppet server
#
File { ignore => '.svn' }
#include splunk::app::unix
  #Package['splunk'] { ensure => latest }

  $apppath = '/opt/splunk/etc/apps/SplunkLightForwarder/local'

  augeas { 'forwarder_local/server.conf':
    context =>  '/files/opt/splunk/etc/system/local/server.conf',
    changes => [
      'set httpServer/disableDefaultPort True',
    ],
  }
  file {
    # Start SLF App
    '/opt/splunk/etc/apps/SplunkLightForwarder/local':
      ensure  => 'directory',
      owner   => 'splunk',
      group   => 'splunk';

    'outputs.conf':
      ensure  => 'present',
      path    => '/opt/splunk/etc/apps/SplunkLightForwarder/local/outputs.conf',
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0644',
      content => template("$mod$apppath/outputs.conf.erb");

    'app.conf':
      ensure  => 'present',
      path    => '/opt/splunk/etc/apps/SplunkLightForwarder/local/app.conf',
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0644',
      content => template("$mod$apppath/app.conf.erb"),
  }
}
