import math
#import matplotlib
#import matplotlib.pyplot

#angPresc = 1000 # angular prescision
radiansAtATime=.0001

class Circle:
    def __init__(self,x,y,r):
        self.x = x
        self.y = y
        self.radius = r
    def __repr__(self):
        return [self.x,self.y,self.radius]
        
    def freePerim(self,otherCircles):
        freeRadians= 0
        angle = 0
        while(angle <= 2*math.pi):
            angle = angle+radiansAtATime
            x = math.cos(angle)*self.radius
            y = math.sin(angle)*self.radius
            isPointFree = True
            for circle in otherCircles:
                if circle==self:
                    pass # do not check self
                else:
                    distSquared = (x-circle.x)**2+(y-circle.y)**2
                    if (distSquared < (circle.radius)**2):
                        isPointFree = False
                        break
            if(isPointFree):
                freeRadians += radiansAtATime
        return freeRadians*self.radius
            
                    

class CircleFigure:
    circles = []
    def __init__(self,myList=[]):
        self.circles = myList
        pass #no constructor atm
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
    foo = CircleFigure([Circle(0,0,5),Circle(1000000,0,1000000),Circle(0,-1000000,1000000)])
    print(foo.circles[0].freePerim(foo.circles))



if __name__ == "__main__":
    #main()
    from tkinter import *

    master = Tk()
    w = Canvas(master, width=200, height=100)
    w.pack()
    w.create_line(0, 0, 200, 100)
    w.create_line(0, 100, 200, 0, fill="red", dash=(4, 4))
    w.create_rectangle(50, 25, 150, 75, fill="blue")

    mainloop()
