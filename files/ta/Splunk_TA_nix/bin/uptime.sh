#!/bin/sh                                                                                                
# Copyright 2005-2013 Splunk, Inc.                                                                       
#                                                                                                        
#   Licensed under the Apache License, Version 2.0 (the "License");                                      
#   you may not use this file except in compliance with the License.                                     
#   You may obtain a copy of the License at                                                              
#                                                                                                        
#       http://www.apache.org/licenses/LICENSE-2.0                                                       
#                                                                                                        
#   Unless required by applicable law or agreed to in writing, software                                  
#   distributed under the License is distributed on an "AS IS" BASIS,                                    
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.                             
#   See the License for the specific language governing permissions and                                  
#   limitations under the License.

. `dirname $0`/common.sh

PRINTF='END {printf "%s SystemUpTime=%s\n", DATE, UPTIME}'

# This should work for any POSIX-compliant system, but in case it doesn't
# we have left the individual OS names here to be broken out later on.
if [ "x$KERNEL" = "xLinux" -o "x$KERNEL" = "xSunOS" -o "x$KERNEL" = "xAIX" -o "x$KERNEL" = "xHP-UX" -o "x$KERNEL" = "xDarwin" -o "x$KERNEL" = "xFreeBSD" ] ; then
        assertHaveCommand date
        assertHaveCommand ps
        CMD='eval date; LC_ALL=POSIX ps -o etime= -p 1'
        # Get the date.
        PARSE_0='NR==1 {DATE=$0}' 
        # Parse timestamp using only POSIX AWK functions. The match, do/while,
        # and exponentiation commands may not be available on some systems.
        PARSE_1='NR==2 {
						if (index($1,"-") != 0) {
							split($1, array, "-")
							UPTIME=86400*array[1]
							num=split(array[2], TIME, ":")
						} else {
							UPTIME=0
							num=split($1, TIME, ":")
						}
						for (i=num; i>0; i--) {
							SECS=TIME[i]
							for (j=num-i; j>0; j--) {
								SECS = SECS * 60
							}
							UPTIME = UPTIME + SECS
						}
					}'
        MASSAGE="$PARSE_0 $PARSE_1"
fi

$CMD | tee $TEE_DEST | $AWK "$HEADERIZE $MASSAGE $FILL_BLANKS $PRINTF" header="$HEADER"
echo "Cmd = [$CMD];  | $AWK '$HEADERIZE $MASSAGE $FILL_BLANKS $PRINTF' header=\"$HEADER\"" >> $TEE_DEST