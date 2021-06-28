def insertionSort(alist):
	for index in range(1,len(alist)):
		print("index",index)
		element = alist[index]
		print("element",element)

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