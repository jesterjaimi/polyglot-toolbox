#!/usr/bin/env python
#read_file.py - file io  in python.

# Open a file
fo = open("foo.txt", "rw+")
print "Name of the file: ", fo.name
print "Closed or not : ", fo.closed
print "Opening mode : ", fo.mode
print "Softspace flag : ", fo.softspace

# Assuming file has following 5 lines
# This is 1st line
# This is 2nd line
# This is 3rd line
# This is 4th line
# This is 5th line

for line in fo:
    print line

line = fo.read(10)
print "Read Line: %s" % (line)

# Close opend file
fo.close()
