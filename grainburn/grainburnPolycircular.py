from libcircle import * # so we dont have to do libcircle.everything
from tkinter import *


#import matplotlib.pyplot as plt
#import matplotlib.image as mpimg # is needed to read in .pngs and convert them to images

class Fuelgrain(CircleFigure):
    def __init__(self,myList=[],pR=.12,a=.104,n = .352,MDotOx=4.3182,fuelDensity=930): #todo - real burn coeffs.
        CircleFigure.__init__(self,myList,pR) # python super() =/= java super() :/
        self.a = a
        self.n = n
        self.MDotOx = MDotOx
        self.fuelDensity=fuelDensity
    def RDot(self):
        return self.a*.001*((self.MDotOx/self.monteCarloArea())**self.n) # need that .001 to convert to m/s
    def neededLength(self,MDotFuel=.6712):
        #if self.warningFlag:
        #    return self.warningFlag ##damn warning flag isnt working. I'll just get to work on a graphical interface
        #else:

        #fuel mass flow rate = RDot * fuelDensity * perimeter * length
        #lenth = MDotFuel / (RDot * fuelDensity * perimeter)
        return MDotFuel / (self.RDot() * self.fuelDensity * self.perimeter() )

def main(): #tkinter stuff
    global foo # so i can view its vars from the terminal after close
    foo = Fuelgrain()
  
    
    #foo.addNew(0,0,.03) #todo - replace this code with .jgrn loading (and make a .jgrn editor)
    foo.addNew(.031,0,.03)
    #foo.addNew(-.031,0,.03)
    foo.addNew(0,.03,.03)
    #foo.addNew(0,-.03,.03)


    
    canvasSize = 1024 # change me
    normalizationFactor = canvasSize/(foo.phenolicRadius)

    
    master = Tk()

    w = Canvas(master, width=canvasSize, height=canvasSize)
    w.pack()
    w.create_oval(0,0,foo.phenolicRadius*normalizationFactor,foo.phenolicRadius*normalizationFactor,outline="black")
    for circle in foo.circles:
        x = (canvasSize/2)+(circle.x * normalizationFactor)
        y = (canvasSize/2)+(circle.y * normalizationFactor)
        radius = circle.radius*normalizationFactor*.5

        w.create_oval(x-radius,y-radius,x+radius,y+radius,outline="red",fill="blue")

    neededLen = foo.neededLength()
    area = foo.monteCarloArea()

    w.create_text(0,10,anchor=W,text="Needed grain length based on 2nd period data: "+str(neededLen))

    mainloop()
    
    

if __name__ == "__main__":
    main()
