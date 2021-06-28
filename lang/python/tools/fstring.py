#!/usr/bin/env python
import math

name = 'Peter'
age = 23

print('%s is %d years old' % (name, age))
print('{} is {} years old'.format(name, age))
print(f'{name} is {age} years old')

user = {'name': 'John Doe', 'occupation': 'gardener'}

print(f"{user['name']} is a {user['occupation']}")

x = 0.8

print(f'{math.cos(x) = }')
print(f'{math.sin(x) = }')

name = 'John Doe'
age = 32
occupation = 'gardener'

msg = (
    f'Name: {name}\n'
    f'Age: {age}\n'
    f'Occupation: {occupation}'
)

print(msg)

def mymax(x, y):
    
    return x if x > y else y

a = 3
b = 4

print(f'Max of {a} and {b} is {mymax(a, b)}')

print("class")

class User:
    def __init__(self, name, occupation):
        self.name = name
        self.occupation = occupation

    def __repr__(self):
        return f"{self.name} is a {self.occupation}"

u = User('John Doe', 'gardener')

print(f'{u}')

print("escaping")
print(f'Python uses {{}} to evaludate variables in f-strings')
print(f'This was a \'great\' film')

print("format")
print("datetime")
import datetime

now = datetime.datetime.now()

print(f'{now:%Y-%m-%d %H:%M}')

print("floats")
val = 12.3

print(f'{val:.2f}')
print(f'{val:.5f}')

print("width")
for x in range(1, 11):
    print(f'{x:02} {x*x:3} {x*x*x:4}')

print("justify")
s1 = 'a'
s2 = 'ab'
s3 = 'abc'
s4 = 'abcd'

print(f'{s1:>10}')
print(f'{s2:>10}')
print(f'{s3:>10}')
print(f'{s4:>10}')

print("numeric notations")
a = 300

# hexadecimal
print(f"{a:x}")

# octal
print(f"{a:o}")

# scientific
print(f"{a:e}")