class { 'splunk':
  type => 'indexer',
  indexandforward => 'True',
  output_hash => { 'syslog:qradar_group' =>
                     { 'server' => 'q6.itsec.harvard.edu:514' },
                   'tcpout:qradar_tcp' =>
                     { 'server'         => 'q6.itsec.harvard.edu:12468',
                       'sendCookedData' => 'False' }
                 }
}
class { 'splunk::inputs':
  input_hash =>  { 'splunktcp://50514' => {} }
}
class { 'splunk::props':
  input_hash => {
                  'lsof' =>
                    { 'TRANSFORMS-null' => 'setnull' },
                  'ps' =>
                    { 'TRANSFORMS-null' => 'setnull' },
                  'linux_secure' =>
                    { 'TRANSFORMS-nyc'  => 'send_to_qradar' },
                  'WinEventLog:Security' =>
                    { 'TRANSFORMS-nyc'  => 'send_to_qradar_tcp' }
                }
}
class { 'splunk::transforms':
  input_hash => {
                  'setnull' =>
                    { 'REGEX'    => '.',
                      'DEST_KEY' => 'queue',
                      'FORMAT'   => 'nullQueue' },
                  'send_to_qradar' =>
                    { 'REGEX'    => '.',
                      'DEST_KEY' => '_SYSLOG_ROUTING',
                      'FORMAT'   => 'qradar_group' },
                  'send_to_qradar_tcp' =>
                    { 'REGEX'    => '.',
                      'DEST_KEY' => '_TCP_ROUTING',
                      'FORMAT'   => 'qradar_tcp' }
                }
}
splunk::ta::files { 'Splunk_TA_nix': }
