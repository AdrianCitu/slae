#Script that tahes as input some chars (letters, numbers) transforms it 
#in ASCII code and then to HEX value.

#!/bin/bash


for c in $@
do
  ascii_result="ASCII value:"
  ascii_value=`printf '%d\n' "'$c"`
  ascii_result+=$ascii_value
  echo $ascii_result
  
  hex_result="HEX VALUE:"
  hex_value=`printf "%04X" $ascii_value |grep -o ..|tac|tr -d '\n'`
  hex_result+=$hex_value
  echo $hex_result
  echo "----------------------------------------------------------------"
done

