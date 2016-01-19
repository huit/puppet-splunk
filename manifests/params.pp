class splunk::params {
  $configure_outputs = true
  $index             = 'os'
  $index_hash        = { }
  $nagios_contacts   = undef
  $splunkadmin       = ':admin:$1$QfZoXMjP$jafmv2ASM45lllqaXHeXv/::Administrator:admin:changeme@example.com:'
  $target_group      = { example1 => 'server1.example.com',
                        example2 => 'server2.example.com' }
  $type              = 'uf'
  $localusers        = undef
  $output_hash       = { }
  $port              = '9997'
  $proxyserver       = undef
  $purge             = undef
  $version           = 'installed'
  $replace_passwd    = 'no'
  $user              = 'root'
  $group             = 'root'

  if $::osfamily == 'RedHat' {
    $init_system = 'sysv_compat'
    $init_confdir = '/etc/sysconfig'
  } elsif $::osfamily == 'Debian' {
    $init_system = 'sysv_compat'
    $init_confdir = '/etc/default'
  } elsif $::osfamily == 'Solaris' {
    $init_system = 'smf'
    $init_confdir = undef
  }

  if $::mode == maintenance {
    $service_ensure = 'stopped'
    $service_enable = false
  } else {
    $service_ensure = 'running'
    $service_enable = true
  }
}
