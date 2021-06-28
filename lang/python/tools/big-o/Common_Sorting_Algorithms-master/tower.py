def moveTower(height,fromPole1, toPole3, withPole2):
   if height >= 1:
       moveTower(height-1,fromPole1,withPole2,toPole3)
       print("moving disk fromPole1 {} withPole2 {} toPole3 {}".format(fromPole1,withPole2,toPole3))
       moveDisk(fromPole1,toPole3)
       moveTower(height-1,withPole2,toPole3,fromPole1)

def moveDisk(fp,tp):
   print("moving disk from", fp, "to" ,tp)

moveTower(3,"A1","B2","C3")