from collections import OrderedDict 
from operator import getitem 
  
# initializing dictionary 
test_dict = {'Nikhil' : { 'roll' : 24, 'marks' : 17}, 
             'Akshat' : {'roll' : 54, 'marks' : 12},  
             'Akash' : { 'roll' : 12, 'marks' : 15}} 
  
# printing original dict 
print("The original dictionary : " + str(test_dict)) 
  
# using OrderedDict() + sorted() 
# Sort nested dictionary by key 
res = OrderedDict(sorted(test_dict.items(), 
       key = lambda x: getitem(x[1], 'marks'))) 
  
# print result 
print("The sorted dictionary by marks is : " + str(res)) 

res2 = OrderedDict(sorted(test_dict.items(), 
       key = lambda x: getitem(x[1], 'marks'), reverse=True)) 

# print result 
print("The reverse sorted dictionary by marks is : " + str(res2)) 