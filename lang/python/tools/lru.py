import time
#from collections import OrderedDict
#from operator import getitem 

class Lru:

    cache = {str(i):{'SESSION': time.time(),'DATA': "BLAH"} for i in [1,2,3,4,5]}

    def get(self, key):
        print(f"get({key})")
        if self.cache.get(key) is None:
            print("missing key")
            return -1
        else:
            data = self.cache[key]['DATA']

        now = time.time()
        self.cache[key]['SESSION'] = now
        self.cache[key]['DATA'] = data
        self.popOldest(key)

        return key, self.cache.get(key)

    def getCache(self):
        return self.cache

    def set(self, key, val):
        print(f"set({key}, {val})")
        now = time.time()

        if self.cache.get(key) is None:
            #add key
            session = {key: {'DATA':val, 'SESSION': now}}    
            self.cache.update(session)
        else:
            #update key
            session = {'DATA':val, 'SESSION': now}    
            self.cache[key].update(session)
        
        self.popOldest(key)
        return key, self.cache.get(key)

    def popOldest(self, key):
        print('pop')
        #find session with oldest timestamp
        _sort = {}

        #_sort = OrderedDict(sorted(_cache.items(), key = lambda x: getitem(x[1], 'SESSION'))) 
        _sort = sorted(self.cache.items(), key = lambda x: x[1]['SESSION']) 
        for _ckey in self.cache:
            if key != _ckey:
                return self.cache.pop(_ckey)

            return self.cache.get(key)

    def init(self):
        i = 0
        self.cache = {}
        while i < 10:
            self.cache = {str(i):{'SESSION': time.time(),'DATA': "BLAH"} 
                            for i in [1,2,3,4,5]}
            time.sleep(0.01)
            i += 1

    def run(self):
        print(self.getCache())
        print(self.get('1'))
        print(self.getCache())
        print(self.set('6', "SOME SESSION DATA"))
        print(self.getCache())
        print(self.get('5'))
        print(self.getCache())
        print(self.set('7', "SOME MORE SESSION DATA"))
        print(self.getCache())
        print(self.get('8')) #not in cache   
        print(self.getCache())
        print(self.set('8', "YET MORE SESSION DATA"))
        print(self.getCache())
        print(self.get('8')) #now in cache
        print(self.getCache())  
        print(self.set('9', "LAST BIT O DATA")) #last cache
        print(self.getCache())
        print(self.get('9')) #9 in cache  
        print(self.getCache())

def main(lru):
    print ("main")
    lru.run()
    print ("end")
    

if __name__== "__main__":
    try:
        lru = Lru()
        lru.init()
    except:
        print("Something went wrong")
    else:
        main(lru)

