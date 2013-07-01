splunk

This is the HUIT Splunk module.  It requires these Puppet Modules:

'cprice404/inifile'
'puppetlabs/stdlib'

This Module also makes a number of assumptions. 

- The Splunk Package is hosted in the package managment repository of your choice and is availible for puppet to install using the package type. 



Disabled inputs for  sourcetype "lsof" "ps" as they are chatty and create a lot of events

## Pre-Commit Hook
To use the pre-commit hook supplied (taken from another github repo, url to be supplied, link the hook to .git/hooks with this command
ln -s pre-commit.puppet-lint .git/hooks/pre-commit

## Example Usage

### Splunk Universal Forwarder

> The Below example configures a Universal Forwarder to send data to
an index server at IP 1.2.3.4 and port 50514, but does not specify any inputs.

```Puppet
class { 'splunk':
  port         => '50514',
  target_group => { 'name' => '1.2.3.4' },
}
```

### Splunk Light Weight Forwarder

> This example configures a Light Weight Forwarder to forward data to index
server splunkindex.example.edu at port 50514, and sets the default index to
"ns-os". In addition, we define the Splunk Unix TA as an app with its default
inputs

```Puppet
class { 'splunk':
  index        => 'ns-os',
  type         => 'lwf',
  port         => '50514',
  target_group => { 'name' => 'splunkindex.example.edu' },
}
splunk::ta::files { 'Splunk_TA_nix': }
```
####  Configure Deployment Client
If you have a Splunk Deployment Server set up, you can bind the Splunk instance
running on your node to a deployment server with the deploymentclient sub class.
Add this to your node.pp or site/<node type module>. In the below example we are managing
A Light Weight Forwarder with foo.com on port 8089.  Please NOTE - Some basic aspects of
the client are still under Puppet Control. 
- Version
- Admin PW
- Type
```Puppet
class { 'splunk':
  type => 'lwf',
}
class { 'splunk::deploymentclient':
  targeturi => 'foo.com:8089',
}

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
