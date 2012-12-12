class unsg_splunk::app::config {
  $apppath = '/opt/splunk/etc/apps/config'

  package { 'splunk-config':
    ensure  => 'latest',
    notify  => Service['splunk'],
    require => Package['splunk']
  }
  # indexes.conf might be a good option for a definition
  file { 'indexes.conf':
    ensure  => 'present',
    path    => "$apppath/default/indexes.conf",
    owner   => 'splunk',
    group   => 'splunk',
    mode    => '0644',
    require => Package['splunk', 'splunk-config'],
    notify  => Service['splunk'],
    content => template("$::unsg_splunk::mod$apppath/default/indexes.conf.erb");
  }
}
