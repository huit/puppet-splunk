# definition: splunk::ulimit
# Based on code from http://puppet-modules.git.puzzle.ch/
#
#
# Parameters:
#- *name*: the name of the limit to change (instance name).
#- *value*: the value to set for this limit.
#
# Requires:
#
# Sample Usage: splunk::ulimit { "nofile": value => 16384 }
define splunk::ulimit ( $value = '40960' ) {
  augeas { "set splunk $name ulimit":
    context => "/files/etc/security/limits.conf/",
    changes => [
      "set \"domain[last()]\" root",
      "set \"domain[.='root']/type\" -",
      "set \"domain[.='root']/item\" $name",
      "set \"domain[.='root']/value\" $value",
      ],
    onlyif => "match domain[.='root'][type='-'][item='$name'][value='$value'] size == 0",
  }
}
