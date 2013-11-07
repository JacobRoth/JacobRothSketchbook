#/usr/bin/env python
#this is the cleaner version implementing a Fuelgrain class
print("hello world")
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import matplotlib.image as mpimg
import numpy as np
import math
import sys
import threading


def convertDown(image): # do not use on grayscale image
    rows,columns,_ = image.shape
    bufferedImage=np.eye(rows,columns)
    for row in range(0,rows):
        for column in range(0,columns):
            bufferedImage[row][column]=image[row][column].any() # returns TRUE if any values are not equal to zero, IE, square is not true black
                
    return np.copy(bufferedImage)

def splitList(myList,numSubLists): #may be slightly off even
    returnList = []
    bisectionPoints  = [ 0 ] # starts out with a zero in there
    distApart = int(len(myList)/numSubLists)

    for iii in range(0,numSubLists-1): # need this to loop numSubLists-1 times
        bisectionPoints.append( bisectionPoints[len(bisectionPoints)-1] + distApart )

    bisectionPoints.append( len(myList) )

    for iii in range(0,len(bisectionPoints)-1):
        returnList.append( myList[bisectionPoints[iii]:bisectionPoints[iii+1]] )
    

    return returnList

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

    def drawCirclesOnGrain(self,pointTuplesList,radius): # accepts a list of points to draw, all the same radius
        for myTuple in pointTuplesList:
            self.drawCircleOnGrain(myTuple,radius)
            #this function might be a great opt target later, but i'm busy

    def regress(self,regression,plist=None):
        if plist == None:
            plist = self.pointsList # if no list of reg points was passed in 
        self.thrustCurve.append(0) # starts at 0 thrust
        for iteration in range(0,regression):
            print(iteration)
            self.thrustCurve.append(self.countSurfaceArea())
            self.animationImageList.append(np.copy(self.image))
            for myTuple in plist:
                self.drawCircleOnGrain(myTuple,iteration)
        self.thrustCurve.append(0) # this is done to make sure the resulting graph
                                   # scales from 0 on the y-axis. you could also say
                                   # it represents thrust at oxidizer depletion.

    def regressMT(self,regression,numThreads):
        if int(math.log(numThreads,2)) != math.log(numThreads,2): #ie, if math.log(numThreads,2) is not a whole number
            print("please make numThreads a power of two, cannot compute")
            return "error"
        else:
            self.thrustCurve.append(0)
            multiPointsLists = splitList(self.pointsList,numThreads)
            for iteration in range(0,regression):
                countThread = threading.Thread(target=self.thrustCurve.append, args=[self.countSurfaceArea()] )
                countThread.start()

                imageThread = threading.Thread(target=self.animationImageList.append, args = [np.copy(self.image)])
                imageThread.start()

                countThread.join()
                imageThread.join()
                
                activeThreads = []
                for pList in multiPointsLists:
                    print(iteration,len(pList))
                    activeThreads.append(threading.Thread(target=self.drawCirclesOnGrain, args=[pList, iteration]))
                    activeThreads[-1].start() # start the one just appened
                for myThread in activeThreads:
                    myThread.join()
            self.thrustCurve.append(0)

                
                    
    
    def regressPolythreaded(self,regression,plist=None): # one thread per circle, not efficient. has to join them all up each iteration, choking the progrram flow
        if plist == None:
            plist = self.pointsList # if no list of reg points was passed in 
        self.thrustCurve.append(0) # starts at 0 thrust
        for iteration in range(0,regression):
            print(iteration)
            self.thrustCurve.append(self.countSurfaceArea())
            self.animationImageList.append(np.copy(self.image))

            myThreads = [] #gets filled up with 1 thread for each circle to be draw this iteration
            for myTuple in plist: # len(plist) is on the order of hundreds, at least, so that's a lot.
                myThreads.append(threading.Thread(target=self.drawCircleOnGrain, args=[myTuple,iteration]))

                myThreads[-1].start()

            for thread in myThreads:
                thread.join()
                    
        self.thrustCurve.append(0)

    


                
                                   

def main():
    # i feel like i should rewrite this whole rendering code to be OO (under class Fuelgrain), but this works as-is and is clean
    global fuelgrain
    fuelgrain = Fuelgrain("cylindrical.png")


    #return

    #fuelgrain.regress(30)
    fuelgrain.regressMT(30,4)

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
