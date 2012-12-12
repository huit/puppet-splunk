(* Splunk module for Augeas
 Author: Tim Hartmann <tfhartmann@gmail.com>

 Splunk uses standard INI Files... so far as I know...
 This module was based on the puppet.conf module and hopefully 
 will just work
*)


module Splunk =
  autoload xfm

(************************************************************************
 * INI File settings
 *
 * puppet.conf only supports "# as commentary and "=" as separator 
 * so we are going to use that convention for splunk.conf files as well
 *************************************************************************)
let comment    = IniFile.comment "#" "#"
let sep        = IniFile.sep "=" "="


(************************************************************************
 *                        ENTRY
 * splunk .conf files use INI File entries
 *************************************************************************)
let entry   = IniFile.indented_entry IniFile.entry_re sep comment


(************************************************************************
 *                        RECORD
 * splunk .conf files use INI File records
 *************************************************************************)
let title   = IniFile.indented_title IniFile.record_re
let record  = IniFile.record title entry


(************************************************************************
 *                        LENS & FILTER
 * splunk .conf files use INI File records
 *************************************************************************)
let lns     = IniFile.lns record comment

let filter = (
             incl "/opt/splunk/etc/system/local/*.conf"
           . incl "/opt/splunk/etc/apps/*/local/*.conf"
             )

let xfm = transform lns filter
