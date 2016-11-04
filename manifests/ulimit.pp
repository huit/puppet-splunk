# == Definition: splunk::ulimit
#
#   Optional definition to set a ulimit for your Splunk servers
#   Based on code from http://puppet-modules.git.puzzle.ch/
#
# === Parameters
#
# Document parameters here.
#
# [name]
#   Name of the limit to change (instance name).
#
# [value]
#   The value to set for this limit.
#
# === Examples
#
#  splunk::ulimit { 'nofile':
#    value => '16384',
#  }
#
define splunk::ulimit ( $user = 'root', $value = '40960' ) {
  augeas { "set splunk ${name} ulimit":
    context => '/files/etc/security/limits.conf/',
    changes => [
      "set \"domain[last()]\" ${user}",
      "set \"domain[.='${user}']/type\" -",
      "set \"domain[.='${user}']/item\" ${name}",
      "set \"domain[.='${user}']/value\" ${value}",
      ],
    onlyif  => "match domain[.='${user}'][type='-'][item='${name}'][value='${value}'] size == 0",
  }
}
