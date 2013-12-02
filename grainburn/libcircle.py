import math,random

radiansAtATime=.0001

class Circle:
    def __init__(self,x,y,r):
        self.x = x
        self.y = y
        self.radius = r

    def expand(self,amount):
        self.radius += amount

    def isInsideMe(self,x,y):
        margin =  (self.radius**2) - ( ((x-self.x)**2) + ((y-self.y)**2) )

    def circum(self):
        return 2*self.radius*math.pi

    def edgePoint(self,angle):
        x = self.x + math.cos(angle)*self.radius
        y = self.y + math.sin(angle)*self.radius
        return x,y
    
    def freePerim(self,otherCircles,phenolicRadius=9e99): # this function is broken
        warningFlag = False
        freeRadians= 0
        angle = 0
        while(angle <= 2*math.pi):
            angle += radiansAtATime
            x = self.x + math.cos(angle)*self.radius
            y = self.y + math.sin(angle)*self.radius
            isPointFree = True
            if (x**2)+(y**2) > phenolicRadius**2:
                warningFlag = True
                isPointFree = False #is point outside the phenolic? if so it doesnt count towards perimeter
            else: # only run the check for collisions with other circles if its inside phenolic
                for circle in otherCircles:
                    if circle==self:
                        pass # do not check self 
                    else:
                        if circle.isInsideMe(x,y):
                            isPointFree = False
                            break
                            
            if(isPointFree):
                freeRadians += radiansAtATime
        return freeRadians*self.radius #,warningFlag
            
                    

class CircleFigure:
    circles = []
    phenolicRadius = 0
    warningFlag = False # gets flipped to True if there's burn surface outside the phen

    
    def __init__(self,myList=[],pR=.12):
        self.circles = myList
        self.phenolicRadius = pR
        self.warningFlag = False 
    def addNew(self,x,y,r):
        self.circles.append(Circle(x,y,r))
    def expand(self,amount):
        for iii in self.circles:
            iii.expand(amount)

    def wipe(self):
        self.circles = []
        
    def perimeter(self): #broken due to reliance on Circle.freePerim
        returnMe = 0
        for circle in self.circles:
            returnMe += circle.freePerim(self.circles,self.phenolicRadius)
        
        return returnMe

    def isInsideMe(self,x,y): 
        returnMe=False
        if x**2+y**2 > self.phenolicRadius**2:
            return returnMe # if its outside the phen radius, its not inside me
        for circle in self.circles:
            if circle.isInsideMe(x,y):
                returnMe = True
                break
        return returnMe

    def monteCarloPerimeter(self,points=10000):
        validPoints = 0
        for iii in range(points):
            c = random.choice(self.circles)
            x,y = c.edgePoint(random.uniform(0,math.pi*2))
            if self.isInsideMe(x,y):
                pass # not a valid point
            else:
                validPoints += 1
        proportion = validPoints/points
        return proportion # for now

    def monteCarloArea(self,points=2000):
        insidePoints = 0
        squareArea = (2*self.phenolicRadius)**2 # area is squareArea * (insidepoints/points)
        for iii in range(points):
            x = random.uniform(-1*self.phenolicRadius,self.phenolicRadius)
            y = random.uniform(-1*self.phenolicRadius,self.phenolicRadius)
            if self.isInsideMe(x,y):
                insidePoints += 1
        return squareArea*(insidePoints/points)
    
    def scatterList(self): #returns 3 lists that matplotlib.pyplot.scatter() can handle
        xlst = []
        ylst = []
        slst = [] # size
        for circle in self.circles:
            xlst.append(circle.x)
            ylst.append(circle.y)
            slst.append(circle.radius)
        return xlst,ylst,slst
    
    
def main():
    foo = CircleFigure([Circle(.05,0,.05),Circle(0,0,.05)],.12)
    print(foo.monteCarloArea(100000))

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
