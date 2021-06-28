#!/usr/bin/env python
'''
author ~ jaimi becker
file: list_comp.py
desc: basic list comprehension code
8/29/2017 @ 13:45 EST
'''
# You can either use loops:
squares = []

for x in range(10):
    squares.append(x**2)

print (squares)

# Or you can use list comprehensions to get the same result:
squares = [x**2 for x in range(10)]

print (squares)
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

#Multiply every part of a list by three and assign it to a new list.

list1 = [3,4,5]

multiplied = [item*3 for item in list1]

print (multiplied)

#take the first letter of each word and make a list out of it.

listOfWords = ["this","is","a","list","of","words"]

items = [ word[0] for word in listOfWords ]

print (items)

# dict comprehension to create dict with numbers as values
#ex1
{str(i):i for i in [1,2,3,4,5]}
#{'1': 1, '3': 3, '2': 2, '5': 5, '4': 4}

#ex2
# create list of fruits
fruits = ['apple', 'mango', 'banana','cherry']
# dict comprehension to create dict with fruit name as keys
{f:len(f) for f in fruits}

#ex3
{f:f.capitalize() for f in fruits}

#ex4
# dict comprehension example using enumerate function
{f:i for i,f in enumerate(fruits)}

#ex5
# dict comprehension example to reverse key:value pair in a dictionary
f_dict = {f:i for i,f in enumerate(fruits)}
print(f_dict)
# dict comprehension to reverse key:value pair in a dictionary
{v:k for k,v in f_dict.items()}