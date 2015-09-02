#Script that take as input an IP v4 adress and compute the hex value in big endian format
#!/bin/bash

IFS='.' read -ra NAMES <<< "$1"    #Convert string to array

#Print all values from array
for (( idx="${#NAMES[@]}"-1 ; idx>=0 ; idx-- )) ; do
    hexValue=`printf %04X "${NAMES[idx]}" |grep -o ..|tac|tr -d '\n'`
    decimalPlusHex="${NAMES[idx]}"
    decimalPlusHex+="("
    decimalPlusHex+=$hexValue
    decimalPlusHex+=")"
    echo $decimalPlusHex
done

#port=`printf %04X $1 |grep -o ..|tac|tr -d '\n'`

#echo $port


