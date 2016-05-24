import os
import sys
f = open("temp.log", "r")
types = []
i = 0
for line in f:
	chs = line.split(" ")
	if chs[4] not in types and "t." in chs[4]:
		types.append(chs[4])

for t in types:
	print t
