class { 'splunk':
  type => 'indexer',
  output_hash => { 'syslog:qradar_group' => 
                     { 'server' => 'q6.itsec.harvard.edu:514' }
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
                    { 'TRANSFORMS-nyc'  => 'send_to_qradar' }
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
                      'FORMAT'   => 'qradar_group' }
                }
}
splunk::ta::files { 'Splunk_TA_nix': }
