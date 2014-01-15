def regressionRate(r):
    return (.000999733/r)

def testRun(rInitial,dT=.01,burnTime=18.5): #seconds
    radius = rInitial
    time = 0
    while(time<burnTime):
        rDot = regressionRate(radius)
        radius = radius + rDot*dT
        time = time+dT
        #if ( int(time/.01) == time/.01):
        print(str(radius)+"   "+str(time))

testRun(.03)
