#/usr/bin/env python
#this is the cleaner version implementing a Fuelgrain class
print("hello world")
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import matplotlib.image as mpimg
import numpy as np
import math
import sys

def convertDown(image): # do not use on grayscale image
    rows,columns,_ = image.shape
    bufferedImage=np.eye(rows,columns)
    for row in range(0,rows):
        for column in range(0,columns):
            bufferedImage[row][column]=image[row][column].any() # returns TRUE if any values are not equal to zero, IE, square is not true black
                
    return np.copy(bufferedImage)

class Fuelgrain:
    image = None #1 is nitrous, 0 is fuel, and the edges are all colored .5
    validityMask = None
    pointsList = [] # indexed as row,column (backwards) because that's how MATPLOTLIB rolls
    
    thrustCurve = [] 
    animationImageList = [] #these two get filled after the program runs

    def __init__(self, filename):
        self.image = mpimg.imread(filename)
    
        size,scratch = self.image.shape
        if size != scratch:
            print("error error - that image is not square. I can't work with that.")
            print("please have image width equal image height exactly")
            return "err - nonsquare image"
        else:
            self.prepValidityMask()
            self.colorAllInvalidsGrey()
            self.populatePointsList()

    def prepValidityMask(self):
        if self.image == None:
            print("error error - must have the image initialized before prepping the validity mask")
            return "error"
        else: #all is well
            self.validityMask = np.copy(self.image)
            rows,columns = self.image.shape
            radius = (rows/2)-1
            rsquared = radius*radius
            for row in range(0,rows):
                for column in range(0,columns):
                    
                    self.validityMask[row][column] =  ((row-radius)**2 + (column-radius)**2 <= rsquared)
                    
        
        
    
    
    def isPointValid(self,pointTuple):
        '''if pointTuple[0] < 0 or pointTuple[1] < 0:
            return False
        if pointTuple[0] >= self.image.shape[0] or pointTuple[1] >= self.image.shape[1]:
            return False
        
        radius,scratch = self.image.shape
        radius = (radius/2)-1 # was actually diameter previously. This gives "radius" as the coordinate for the center. X coord = Y coord
        rsquared = radius**2
        if (pointTuple[0]-radius)**2 + (pointTuple[1]-radius)**2 > rsquared:
            return False
        else:
            return True ''' # that was the old code, now it uses validity mask

        return self.validityMask[pointTuple[0]][pointTuple[1]]
        
        

    def colorAllInvalidsGrey(self):
        rows,columns = self.image.shape
        for row in range(0,rows):
            for column in range(0,columns):
                if self.isPointValid((row,column)):
                    pass
                else:
                    self.image[row][column] = 0.5
        
    def populatePointsList(self): #uses edge detection, making the pointsList much shorter but still definitive
        #remember, in the image 1 is nitrous/bore, and 0 is fuel
        rows,columns = self.image.shape
        for row in range(0,rows):
            for column in range(0,columns):
                if self.image[row][column] == 1: #nitrous
                    if self.isPointValid((row,column)):
                        addOne = False
                        if self.isPointValid((row,column-1)):
                            if self.image[row][column-1] == 0: #touching a fuel square, so we are on the edge
                                addOne=True
                        if self.isPointValid((row,column+1)):
                            if self.image[row][column+1] == 0: #touching a fuel square, so we are on the edge
                                addOne=True
                        if self.isPointValid((row-1,column)):
                            if self.image[row-1][column] == 0: #touching a fuel square, so we are on the edge
                                addOne=True
                        if self.isPointValid((row+1,column)):
                            if self.image[row+1][column] == 0: #touching a fuel square, so we are on the edge
                                addOne=True
                        if addOne:
                            self.pointsList.append( (row,column) )

    def countSurfaceArea(self): #count the number of exposed fuel pixels
        count = 0
        rows,columns = self.image.shape
        for row in range(0,rows):
            for column in range(0,columns):
                if self.image[row][column] == 1: #nitrous
                    if self.isPointValid((row,column)):
                        addOne = False
                        if self.isPointValid((row,column-1)):
                            if self.image[row][column-1] == 0: #touching a fuel square, so we are on the edge
                                addOne=True
                        if self.isPointValid((row,column+1)):
                            if self.image[row][column+1] == 0: #touching a fuel square, so we are on the edge
                                addOne=True
                        if self.isPointValid((row-1,column)):
                            if self.image[row-1][column] == 0: #touching a fuel square, so we are on the edge
                                addOne=True
                        if self.isPointValid((row+1,column)):
                            if self.image[row+1][column] == 0: #touching a fuel square, so we are on the edge
                                addOne=True
                        if addOne:
                            count = count+1
        return count

    def drawCircleOnGrain(self,pointTuple,radius):
        rSquared = radius*radius
        for row in range(pointTuple[0]-radius, pointTuple[0]+radius):
            for column in range(pointTuple[1]-radius, pointTuple[1]+radius):
                if (pointTuple[0]-row)**2 + (pointTuple[1]-column)**2 < rSquared:
                    if self.isPointValid((row,column)):
                        self.image[row][column] = 1 # make it nitrous

    def regressMe(self,regression):
        self.thrustCurve.append(0) # starts at 0 thrust
        for iteration in range(0,regression):
            print(iteration)
            self.thrustCurve.append(self.countSurfaceArea())
            self.animationImageList.append(np.copy(self.image))
            for myTuple in self.pointsList:
                self.drawCircleOnGrain(myTuple,iteration)
        self.thrustCurve.append(0) # this is done to make sure the resulting graph
                                   # scales from 0 on the y-axis. you could also say
                                   # it represents thrust at oxidizer depletion.
                                   

def main():
    # i feel like i should rewrite this whole rendering code to be OO (under class Fuelgrain), but this works as-is and is clean
    global fuelgrain
    fuelgrain = Fuelgrain("cylindrical.png")
    fuelgrain.regressMe(30)

    fig=plt.figure()
    imgplot=plt.imshow(fuelgrain.image)

    def updatefig(j):
        imgplot.set_array(fuelgrain.animationImageList[j])
        return imgplot, # i have no idea why this ends with a comma, but it works.

    ani = animation.FuncAnimation(fig,updatefig,frames=range(len(fuelgrain.animationImageList)),interval=90,repeat_delay=200,blit=True)

    plt.show()
    plt.clf()
    plt.plot(fuelgrain.thrustCurve)
    plt.show()

    
if __name__ == "__main__":
    main()
