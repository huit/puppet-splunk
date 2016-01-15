# splunk::inputs should be called to start management your splunk inputs.conf.
# By default inputs.conf will be placed in $splunkhome/etc/system/local/
# To add entries to the file, use splunk::inputs::create
#
# === Parameters
# $path allows you to override the default location of inputs.conf
#
class splunk::inputs ($path = "${::splunk::splunkhome}/etc/system/local") {

  concat {"${path}/inputs.conf":
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0644',
    require => Class['splunk::install'],
    notify  => Class['splunk::service']
  }

  concat::fragment {"Inputs ${name} (Default + FQDN)":
    target  => "${path}/inputs.conf",
    order   => '00',
    content => template('splunk/opt/splunk/etc/system/local/inputs.conf.erb'),
    require => Class['splunk::install'],
    notify  => Class['splunk::service']
  }
}
