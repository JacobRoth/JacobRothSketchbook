import math,random,copy

class Circle:
    def __init__(self,x,y,r):
        self.x = x
        self.y = y
        self.radius = r

    def expand(self,amount):
        self.radius += amount

    def isInsideMe(self,x,y):
        return (self.radius**2) > (((self.x-x)**2)+((self.y-y)**2)) # no safety margin! not suitible for edge operations!

    def circum(self):
        return 2*self.radius*math.pi  
           
                    

class CircleFigure:
    circles = []
    phenolicRadius = 0
    
    def __init__(self,myList=[],pR=.12):
        self.circles = myList
        self.phenolicRadius = pR
        self.warningFlag = False 
    def addNew(self,x,y,r):
        self.circles.append(Circle(x,y,r))

    def expand(self,amount):
        for iii in self.circles:
            iii.expand(amount)

    def expandReturn(self,amount):
        spam = copy.deepcopy(self)
        spam.expand(amount)
        return spam

    def wipe(self):
        self.circles = []


    def isInsideMe(self,x,y): 
        returnMe=False
        if x**2+y**2 > self.phenolicRadius**2:
            return returnMe # if its outside the phen radius, its not inside me
        for circle in self.circles:
            if circle.isInsideMe(x,y):
                returnMe = True
                break
        return returnMe

    def monteCarloArea(self,points=10000):
        insidePoints = 0
        squareArea = (2*self.phenolicRadius)**2 # area is squareArea * (insidepoints/points)
        for iii in range(points):
            x = random.uniform(-1*self.phenolicRadius,self.phenolicRadius)
            y = random.uniform(-1*self.phenolicRadius,self.phenolicRadius)
            if self.isInsideMe(x,y):
                insidePoints += 1
        return squareArea*(insidePoints/points)

    def monteCarloGapArea(self,points=1000000,gapWidth=.005):
        squareArea = (2*self.phenolicRadius)**2
        
        pointsInFigure = 0 #this will include the gap region - innacurate but not too much
        pointsInGapRegion = 0
        largerFigure = self.expandReturn(gapWidth)
        for iii in range(points):
            x = random.uniform(-1*self.phenolicRadius,self.phenolicRadius)
            y = random.uniform(-1*self.phenolicRadius,self.phenolicRadius)
            if largerFigure.isInsideMe(x,y):
                pointsInFigure += 1
                if self.isInsideMe(x,y):
                    pass # it's fully inside, do nothing
                else:
                    pointsInGapRegion += 1 #it's in the border
        gapProportion = pointsInGapRegion/points # proportion of points in gap region
        gapArea = gapProportion*squareArea
        return gapArea
        

##    def monteCarloPA(self,points=1000000,gapWidth=.005): #is going to return perimeter,area
##        squareArea = (2*self.phenolicRadius)**2
##        
##        pointsInFigure = 0 #this will include the gap region - innacurate but not too much
##        pointsInGapRegion = 0
##        largerFigure = self.expandReturn(gapWidth)
##        for iii in range(points):
##            x = random.uniform(-1*self.phenolicRadius,self.phenolicRadius)
##            y = random.uniform(-1*self.phenolicRadius,self.phenolicRadius)
##            if largerFigure.isInsideMe(x,y):
##                pointsInFigure += 1
##                if self.isInsideMe(x,y):
##                    pass # it's fully inside, do nothing
##                else:
##                    pointsInGapRegion += 1 #it's in the border
##        gapProportion = pointsInGapRegion/points # proportion of points in gap region
##        gapArea = gapProportion*squareArea
##        perimeter = gapArea/gapWidth
##        return perimeter,squareArea*(pointsInFigure/points) #that second one is area
        


class Fuelgrain(CircleFigure):
    def __init__(self,myList=[],pR=.12,a=0.104,n=.352,MDotOx=4.382,MDotFuel=.6712,fuelDensity=930):
        CircleFigure.__init__(self,myList,pR)
        self.a = a
        self.n = n
        self.mDotOx=MDotOx
        self.mDotFuel=MDotFuel
        self.fuelDensity=fuelDensity
    def rDot(self):
        return self.a * .001 * ((self.mDotOx / self.monteCarloArea() )**self.n)
    def currentRequiredLength(self,dT=.1):
        return  self.mDotFuel / ( self.fuelDensity * ( self.monteCarloGapArea(self.rDot()*dT)/dT )  ) 
    
    
    
def main():
    global grain
    grain = Fuelgrain()
##    grain.addNew(0,0,.06)
##    grain.addNew(0.0849,0.0849,.03)
##    grain.addNew(-0.06,-0.07,.02)
    grain.addNew(0,0,.0254)
    grain.addNew(.0254,.0254,.0254)
    grain.addNew(.0254,-.0254,.0254) #marielle's grain
    grain.addNew(-.0254,.0254,.0254)
    grain.addNew(-.0254,-.0254,.0254)

    
    print(grain.currentRequiredLength())

if __name__ == "__main__":
    main()
    '''
    from tkinter import *

    master = Tk()
    w = Canvas(master, width=200, height=100)
    w.pack()
    w.create_line(0, 0, 200, 100)
    w.create_line(0, 100, 200, 0, fill="red", dash=(4, 4))
    w.create_rectangle(50, 25, 150, 75, fill="blue")

    mainloop()'''
