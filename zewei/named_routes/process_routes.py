#!/usr/bin/python
import sys

routes_file = sys.argv[1]

with open(routes_file, "rb") as f:
	for line in f:
		line = line.split()
		if len(line) < 1:
			continue
		if line[0] in ["GET", "POST", "PUT", "PATCH", "DELETE", "Prefix"]:
			continue
		named_route = line[0]
		controller_action = line[len(line)-1].split("#")
		if len(controller_action) < 2:
			continue
		print(named_route)
		print("{:controller=>\"" + controller_action[0] + "\", :action=>\"" + controller_action[1] + "\"}")
