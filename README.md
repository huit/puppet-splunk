splunk

This is the splunk module.  It requires Puppet 2.6.2 or later.

Disabled inputs for  sourcetype "lsof" "ps" as they are chatty and create a lot of events

## Pre-Commit Hook
To use the pre-commit hook supplied (taken from another github repo, url to be supplied, link the hook to .git/hooks with this command
ln -s pre-commit.puppet-lint .git/hooks/pre-commit

## Example Usage

### Splunk Universal Forwarder

```Puppet
class { 'splunk':
  port         => '50514',
  target_group => { 'name' => '1.2.3.4' },
}
```


### splunk::ulimit
  splunk::ulimit takes two parameters, the name of the limit to change
  and the number of files to allow.

 [name]
   Name of the limit to change (instance name).

 [value]
   The value to set for this limit.

```Puppet
  splunk::ulimit { 'nofile':
    value => 16384,
  }
```
