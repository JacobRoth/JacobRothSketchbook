import math,random,copy,threading,multiprocessing

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
        self.monteCarloGenerateMT(monteCarloPoints)
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

    def monteCarloGenerateMT(self,points,threads=0):
        if threads == 0:
            threads = multiprocessing.cpu_count()
        myThreads = []
        for iii in range(threads):
            myThreads.append(threading.Thread(target=self.monteCarloGenerate, args=[points/threads]))
            myThreads[-1].start()

        for myThread in myThreads:
            myThread.join()
            
            


    def area(self):
        insidePoints = 0
        for x,y in self.monteCarlo:
            if self.isInsideMe(x,y):
                insidePoints += 1
        return self.phenolicBoundingSquareArea * (insidePoints/len(self.monteCarlo))

##    def areaMT(self): # fsck this, I'll finish it later.
##        insidePoints = 0
##        def 

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


class Fuelgrain(CircleFigure):
    def __init__(self,myList=[],pR=.12,monteCarloPoints=1e7,a=0.104,n=.352,MDotOx=4.382,MDotFuel=.6712,fuelDensity=930):
        CircleFigure.__init__(self,myList=myList,pR=pR,monteCarloPoints=monteCarloPoints)
        self.a = a
        self.n = n
        self.mDotOx=MDotOx
        self.mDotFuelDesired=MDotFuel
        self.fuelDensity=fuelDensity
    def rDot(self,area=0): #if you've already calculated the area elsewhere
        if area == 0:
            area = self.area()
        return self.a * .001 * ((self.mDotOx / area )**self.n)
    def currentRequiredLength(self,dT=.1):
        return  self.mDotFuelDesired / ( self.fuelDensity * ( self.gapArea(gapWidth=(self.rDot()*dT))/dT )  ) 
    def simulatedBurn(self,seconds=20,dT=1,length=0):
        if length==0:
            length=self.currentRequiredLength()
        time = 0
        while time<seconds:
            time += dT
            rDot = self.rDot()
            topViewArea = self.gapArea(gapWidth=(rDot*dT))
            fuelVolume = topViewArea*length

            fuelMass = fuelVolume*self.fuelDensity

            print("At T="+str(time)+" the fuel mass flow is "+ str(fuelMass/dT) + " kg/sec")
            self.expand(rDot*dT)
    def zonesOfRegression(self,zoneWidth=.005,numFigures=25):
        figures = []
        tableOfAreas = []
        figures.append(self)
        for iii in range(numFigures-1):
            figures.append(figures[-1].expandReturn(zoneWidth))
            print("Debug output: computed figure "+str(iii))
            tableOfAreas.append(figures[-1].area())
        tableOfZoneAreas = [] # will have length of len(figures)-1
        for iii in range(len(tableOfAreas)-1):
            ##todo - finish function
            pass
        
    
    
def main():
    print("computing Marielle's fuel grain (again, with new flow rates)")
    print("please don't close me")
    global marielleGrain
    marielleGrain = Fuelgrain(a=.1146,n=.503,MDotOx=3.8181,MDotFuel=0.582,fuelDensity=739.24)
    marielleGrain.addNew(0,0,.0254)
    marielleGrain.addNew(.0254,.0254,.0254)
    marielleGrain.addNew(.0254,-.0254,.0254) 
    marielleGrain.addNew(-.0254,.0254,.0254)
    marielleGrain.addNew(-.0254,-.0254,.0254)

    print(marielleGrain.simulatedBurn(seconds=23))

##    global jacobGrain
##
##    jacobGrain = Fuelgrain()
##    jacobGrain.addNew(0,  0,.05)
##
##    jacobGrain.addNew(0,.08,.03)
##    jacobGrain.addNew(0,-.08,.03)
##    jacobGrain.addNew(.08,0,.03)
##    jacobGrain.addNew(-.08,0,.03)
##    
##    print(jacobGrain.simulatedBurn())

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
