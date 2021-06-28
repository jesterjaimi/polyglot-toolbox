#!/usr/bin/env python
'''
author ~ jaimi becker
file: bst.py
desc: binary search
8/29/2017 @ 13:45 EST
'''
class Node():

    def __init__(self,val):
        self.value = val
        self.left = None
        self.right = None


    def _insert(self,data):
        if data == self.value:
            return False
        elif data < self.value:
            if self.left:
                return self.left._insert(data)
            else:
                self.left = Node(data)
                return True
        else:
            if self.right:
                return self.right._insert(data)
            else:
                self.right = Node(data)
                return True

    def _inorder(self):
        if self:
            if self.left:
                self.left._inorder()
            print(self.value)
            if self.right:
                self.right._inorder()



class Tree():

    def __init__(self):
        self.root = None

    def insert(self,data):
        if self.root:
            return self.root._insert(data)
        else:
            self.root = Node(data)
            return True
    def inorder(self):
        if self.root is not None:
            return self.root._inorder()
        else:
            return False




if __name__=="__main__":
    a = Tree()
    a.insert(16)
    a.insert(8)
    a.insert(24)
    a.insert(6)
    a.insert(12)
    a.insert(19)
    a.insert(29)
    a.inorder()
