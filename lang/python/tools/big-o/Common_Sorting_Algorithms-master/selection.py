def selectionSort():
	for element in range(len(alist)-1):
		print("element", element)
		minimum = element
		print("minimum", minimum)
		for index in range(element+1,len(alist)):
			print("index",index)
			if alist[index] < alist[minimum]:
				print("alist[index]",alist[index])
				print("alist[minimum]",alist[minimum])
				minimum = index
				print("changing minimum", minimum)

		alist[element], alist[minimum] = alist[minimum], alist[element]
		print("swap a,b = b,a",alist[element], alist[minimum]) 

# alist = [54,26,93,17,77,31,44,55,20]
alist = [30,20,10, 15]
selectionSort()
print(alist)

