alist = [54,26,93,17,77,31,44,55,20]
# alist = [30,20,10]

def bubbleSort():
	for a in range(len(alist)):
		print("Index a {} number {}".format(a,alist[a]))
		for b in range(len(alist)-1):
			print("Index b {} number {}".format(b,alist[b]))
			if alist[b]>alist[a]:
				print("if index b {} number {} > index a {} number {}".format(b, alist[b],a,alist[a]))
				
				alist[a], alist[b] = alist[b], alist[a]
				print("swapping b {} and a {}".format(alist[b], alist[a]))

	print(alist)

bubbleSort()

def swap():
	a,b =1,2
	temp = a
	a = b
	b = temp
	print(a,b)
swap()

def swap_two():
	a,b = 1,2
	a,b = b,a
	print(a,b)
swap_two()












