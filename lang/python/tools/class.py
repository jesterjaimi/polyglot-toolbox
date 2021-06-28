#!/usr/bin/env python
#class.py - a class in python.

# class definition is here
class Dog:
    kind = 'canine'         # class variable shared by all instances

    def __init__(self, name):
        self.name = name    # instance variable unique to each instance


d = Dog('Fido')
e = Dog('Buddy')

print("Dog d...")
print(d.name)
print(d.kind)
print("Dog e...")
print(e.name)
print(e.kind)
