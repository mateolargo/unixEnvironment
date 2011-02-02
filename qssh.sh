#!/bin/bash
PROFILES=~/.ssh/profiles
aindex=1
hosts=( null )
# read array
function readHosts(){
 exec 3<&0
 exec 0<$PROFILES
 while read line
 do
    rline=$(echo $line | egrep -v "^#" | sed '/^$/d')
    if [ "$rline" != "" ]; then
        user=$(echo "$rline" |  awk -F'|' '{ print $1}')
        ip=$(echo "$rline" |  awk -F'|' '{ print $2}')
        port=$(echo "$rline" |  awk -F'|' '{ print $3}')
        [ "$port" == "" ] && port=22 || :
        hosts[$aindex]=$(echo "ssh -p$port $user@$ip")
        aindex=` expr $aindex + 1 `
    fi
 done
 exec 0<&3 
}
# display choice and connect to server
function displayHosts(){
  echo "------------------------------------"
  echo "Sr# : SSH Server Host Name"
  echo "------------------------------------"
  for (( i=1; i<$aindex; i++ ))
  do
        echo "#$i : ${hosts[$i]}"
  done
  read -p "Enter host number: " myHostNumber
  echo "Connecting to ${hosts[$myHostNumber]} ..."
  ${hosts[$myHostNumber]}
}

readHosts
if [ $# -ge 1 ]; then
    echo "Connecting to ${hosts[$1]} ..."
    ${hosts[$1]}
else
    displayHosts
fi
