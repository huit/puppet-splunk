class { 'splunk':
  type => 'lwf',
}
class { 'splunk::deploymentclient':
  targeturi => 'foo.com:8089',
}
