class { 'splunk': type => 'indexer', }
class { 'splunk::indexes': }
#class { 'splunk::indexes': 
#  input_hash => { 'dns' => {
#                    'homePath'               => '$SPLUNK_DB/dns/db',
#                    'coldPath'               => '/mnt/splunk/dns/colddb',
#                    'thawedPath'             => '$SPLUNK_DB/dns/thaweddb',
#                    'homePath.maxDataSizeMB' => '102400',
#                    'frozenTimePeriodInSecs' => '3888000' }
#                }
#}
