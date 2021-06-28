#!/usr/bin/env python
'''
author ~ jaimi becker
file: goldman.py
desc: Goldman Sach Codepad Interview Script
8/29/2017 @ 13:45 EST
'''

print("Hello Goldman!")

import functools

def FindLargest(arr):
    # Todo: Implement FindLargest
    largest = -1
    idx = 0
    for item in arr:

        if item.last()

    return ""

def SortLargest(arr):
    #simple SortArr
    sortedArr = sorted(arr)
    #check for Ending Zeros
'''
    for ix = 0, item in sorted, ix++:
        if item[:-1].endswith("0"):
            sorted[ix] = item[0:(len(item) - 1)]
            SortLargest(sorted)
'''
         
def insertionSort(alist):
	for index in range(1,len(alist)):
		print("index",index)
		element = alist[index]
		print("element", element)

		while index > 0 and alist[index-1] > element:
			print("index {}, move {}, element{}".format(index,alist[index-1],element))
			alist[index] = alist[index-1]
			print("Shifting element",alist[index])
			index = index - 1
			print("Updating counter index", index)

		alist[index] = element
		print("Inserting element",element)

alist = [88,33,22,44]
insertionSort(alist)
print(alist)

"""
 Returns true if all tests pass. Otherwise returns false.
"""

def doTestsPass():
    # todo: implement more tests, please
    # feel free to make testing more elegant

    testInputs = [[10, 9], [56, 54, 5], [82, 61, 22, 826], [82, 61, 22, 829]]
    testOutputs = ["910", "56554", "828266122", "829826122"]

    result = True

    for i in range(len(testInputs)):
        result = result and (FindLargest(testInputs[i]) == testOutputs[i])

    if result:
        print("All tests pass")
    else:
        print("There are test failures")

    return result

"""
  Execution entry point.
"""

def main():
    doTestsPass()

main()
