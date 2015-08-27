#!/bin/bash
port=`printf %04X $1 |grep -o ..|tac|tr -d '\n'`

echo $port
