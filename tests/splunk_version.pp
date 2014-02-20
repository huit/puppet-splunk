if $::splunk_version < '6.0.0' {
    notify { "Splunk version ${::splunk_version} will now be purged from this host": } -> class { 'splunk': purge => true }
} else {
    notify { "Splunk version ${::splunk_version} is ok": }
}
