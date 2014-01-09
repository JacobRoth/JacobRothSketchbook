def regressionRate(r):
    return (.053491035/r)*.001

def testRun(rInitial,dT=.01,burnTime=18.5): #seconds
    radius = rInitial
    time = 0
    while(time<burnTime):
        rDot = regressionRate(radius)
        radius = radius + rDot*dT
        time = time+dT
        #if ( int(time/.01) == time/.01):
        print(str(radius)+"   "+str(time))

testRun(.005)
        
    
    
