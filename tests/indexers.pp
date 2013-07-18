class { 'splunk': type => 'indexer', }
class { 'splunk::inputs':
  input_hash =>  { 'splunktcp://50514' => {} }
  }
splunk::ta::files { 'Splunk_TA_nix': }

#class { 'splunk::indexes': 
#  input_hash => { 'dns' => {
#                    'homePath'               => '$SPLUNK_DB/dns/db',
#                    'coldPath'               => '/mnt/splunk/dns/colddb',
#                    'thawedPath'             => '$SPLUNK_DB/dns/thaweddb',
#                    'homePath.maxDataSizeMB' => '102400',
#                    'frozenTimePeriodInSecs' => '3888000' }
#                }
#}
