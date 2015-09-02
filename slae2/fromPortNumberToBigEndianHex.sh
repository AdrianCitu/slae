#Script that take as input a port number and compute the hev value in big endian format
#!/bin/bash
port=`printf %04X $1 |grep -o ..|tac|tr -d '\n'`

echo $port
