def binary(alist, item):
	start = 0
	end = len(alist) - 1
	found = False

	while  start <= end and not found:
		midpoint = (start + end) //2
		print("Original midpoint", midpoint)

		if alist[midpoint] == item:
			print("Midpoint number",alist[midpoint])
			found = True

		else:
			if item < alist[midpoint]:
				end = midpoint - 1
				print("If end", end)

			else:
				start = midpoint + 1
				print("Else start",start)
	return found


alist = [1,2,3,4,5,6,7]
print(binary(alist, 1))