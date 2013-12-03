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
    
    def __init__(self,myList=[],pR=.12,monteCarloPoints=1e7):
        self.circles = myList
        self.phenolicRadius = pR
        self.warningFlag = False
        self.monteCarloGenerate(monteCarloPoints)
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

    def monteCarloGenerate(self,points):
        self.phenolicBoundingSquareArea = (2*self.phenolicRadius)**2 #used in area function
        self.monteCarlo = []
        for iii in range(int(points)):
            self.monteCarlo.append((random.uniform(-1*self.phenolicRadius,self.phenolicRadius),random.uniform(-1*self.phenolicRadius,self.phenolicRadius)))

    def area(self):
        insidePoints = 0
        for x,y in self.monteCarlo:
            if self.isInsideMe(x,y):
                insidePoints += 1
        return self.phenolicBoundingSquareArea * (insidePoints/len(self.monteCarlo))

    def gapArea(self,gapWidth=.005):
        largerFigure = self.expandReturn(gapWidth)
        pointsInGapRegion = 0
        for x,y in self.monteCarlo:
            if largerFigure.isInsideMe(x,y):
                #good, we're inside
                if self.isInsideMe(x,y):
                    #nevermind, it's all the way inside
                    pass
                else:
                    pointsInGapRegion += 1
        return self.phenolicBoundingSquareArea * (pointsInGapRegion/len(self.monteCarlo))
            
        


##
##    def monteCarloArea(self,points=5000000):
##        insidePoints = 0
##        squareArea = (2*self.phenolicRadius)**2 # area is squareArea * (insidepoints/points)
##        for iii in range(points):
##            x = random.uniform(-1*self.phenolicRadius,self.phenolicRadius)
##            y = random.uniform(-1*self.phenolicRadius,self.phenolicRadius)
##            if self.isInsideMe(x,y):
##                insidePoints += 1
##        return squareArea*(insidePoints/points)
##
##    def monteCarloGapArea(self,points=5000000,gapWidth=.005):
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
##        return gapArea
        

        


class Fuelgrain(CircleFigure):
    def __init__(self,myList=[],pR=.12,monteCarloPoints=1e7,a=0.104,n=.352,MDotOx=4.382,MDotFuel=.6712,fuelDensity=930):
        CircleFigure.__init__(self,myList=myList,pR=pR,monteCarloPoints=monteCarloPoints)
        self.a = a
        self.n = n
        self.mDotOx=MDotOx
        self.mDotFuel=MDotFuel
        self.fuelDensity=fuelDensity
    def rDot(self):   # a bunch of calls to monteCarlo functions, please replace
        return self.a * .001 * ((self.mDotOx / self.area() )**self.n)
    def currentRequiredLength(self,dT=.1):
        return  self.mDotFuel / ( self.fuelDensity * ( self.gapArea(gapWidth=(self.rDot()*dT))/dT )  ) 
    
    
    
def main():
    global marielleGrain
    marielleGrain = Fuelgrain(a=.1146,n=.503,MDotOx=4.4318,MDotFuel=.68182,fuelDensity=739.24)
    marielleGrain.addNew(0,0,.0254)
    marielleGrain.addNew(.0254,.0254,.0254)
    marielleGrain.addNew(.0254,-.0254,.0254) 
    marielleGrain.addNew(-.0254,.0254,.0254)
    marielleGrain.addNew(-.0254,-.0254,.0254)

    
    print(marielleGrain.currentRequiredLength())

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
