from libcircle import * # so we dont have to do libcircle.everything
#import matplotlib.pyplot as plt
#import matplotlib.image as mpimg # is needed to read in .pngs and convert them to images

class Fuelgrain(CircleFigure):
    def __init__(self,myList=[],pR=.12,a=.104,n = .3,MDotOx=4.31,fuelDensity=930): #todo - real burn coeffs.
        CircleFigure.__init__(self,myList,pR) # python super() =/= java super() :/
        self.a = a
        self.n = n
        self.MDotOx = MDotOx
        self.fuelDensity=fuelDensity
    def MDotFuel(self):
        return #ugh, fix this later
