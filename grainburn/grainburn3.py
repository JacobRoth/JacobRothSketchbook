#/usr/bin/env python
#this entire code is written without any classes. functional programming
#maybe I'll rewrite this in fotran one day, lol
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

def isPointValid(pointTuple,fuelgrain):
    if pointTuple[0] < 0 or pointTuple[1] < 0:
        return False
    if pointTuple[0] >= fuelgrain.shape[0] or pointTuple[1] >= fuelgrain.shape[1]:
        return False
    
    radius,scratch = fuelgrain.shape
    if radius != scratch:
        print("error attempting to validate point on nonsquare image. cannot proceed")
        return "error attempting to validate point on nonsquare image. cannot proceed"
    radius = (radius/2)-1 # was actually diameter previously. This gives "radius" as the coordinate for the center. X coord = Y coord
    rsquared = radius**2
    if (pointTuple[0]-radius)**2 + (pointTuple[1]-radius)**2 > rsquared:
        return False
    else:
        return True

def colorAllInvalidsGrey(fuelgrain):
    rows,columns = fuelgrain.shape
    for row in range(0,rows):
        for column in range(0,columns):
            if isPointValid((row,column),fuelgrain):
                pass
            else:
                fuelgrain[row][column] = 0.5
    
def populatePointsListSmart(pointsList, image): #adds edge detection, making the pointsList much shorter but still definitive
    #remember, in the image 1 is nitrous/bore, and 0 is fuel
    rows,columns = image.shape
    for row in range(0,rows):
        for column in range(0,columns):
            if image[row][column] == 1: #nitrous
                if isPointValid((row,column),image):
                    addOne = False
                    if isPointValid((row,column-1),image):
                        if image[row][column-1] == 0: #touching a fuel square, so we are on the edge
                            addOne=True
                    if isPointValid((row,column+1),image):
                        if image[row][column+1] == 0: #touching a fuel square, so we are on the edge
                            addOne=True
                    if isPointValid((row-1,column),image):
                        if image[row-1][column] == 0: #touching a fuel square, so we are on the edge
                            addOne=True
                    if isPointValid((row+1,column),image):
                        if image[row+1][column] == 0: #touching a fuel square, so we are on the edge
                            addOne=True
                    if addOne:
                        pointsList.append( (row,column) )

def countSurfaceArea(image): #count the number of exposed fuel pixels
    count = 0
    rows,columns = image.shape
    for row in range(0,rows):
        for column in range(0,columns):
            if image[row][column] == 1: #nitrous
                if isPointValid((row,column),image):
                    addOne = False
                    if isPointValid((row,column-1),image):
                        if image[row][column-1] == 0: #touching a fuel square, so we are on the edge
                            addOne=True
                    if isPointValid((row,column+1),image):
                        if image[row][column+1] == 0: #touching a fuel square, so we are on the edge
                            addOne=True
                    if isPointValid((row-1,column),image):
                        if image[row-1][column] == 0: #touching a fuel square, so we are on the edge
                            addOne=True
                    if isPointValid((row+1,column),image):
                        if image[row+1][column] == 0: #touching a fuel square, so we are on the edge
                            addOne=True
                    if addOne:
                        count = count+1
    return count

def drawCircleOnGrain(pointTuple,radius,fuelgrain):
    rSquared = radius*radius
    for row in range(pointTuple[0]-radius, pointTuple[0]+radius):
        for column in range(pointTuple[1]-radius, pointTuple[1]+radius):
            if (pointTuple[0]-row)**2 + (pointTuple[1]-column)**2 < rSquared:
                if isPointValid((row,column),fuelgrain):
                    fuelgrain[row][column] = 1 # make it nitrous

def main():

    global pointsList
    global fuelgrain
    global thrustCurve
    global animationImageList

    fig=plt.figure()
    
    pointsList = [] # indexed as row,column (backwards) because that's how MATPLOTLIB rolls

    fuelgrain = mpimg.imread(sys.argv[0])
    colorAllInvalidsGrey(fuelgrain)
    
    size,scratch = fuelgrain.shape
    if size != scratch:
        print("error error - that image is not square. I can't work with that.")
        print("please have image width equal image height exactly")
        return "err - nonsquare image"

    populatePointsListSmart(pointsList ,fuelgrain)

    thrustCurve = []
    animationImageList = []
    
    regression = int(sys.argv[1])
    for iteration in range(0,regression):
        print(iteration)
        thrustCurve.append(countSurfaceArea(fuelgrain))
        animationImageList.append(np.copy(fuelgrain))
        #animationImageList.append(np.copy(fuelgrain))
        for myTuple in pointsList:
            drawCircleOnGrain(myTuple,iteration,fuelgrain)


    
    imgplot=plt.imshow(fuelgrain)
    #imgplot.set_cmap("gray") # sets the correct color scheme
    #plt.show()

    #should be able to make animation with this code:
    def updatefig(j):
        imgplot.set_array(animationImageList[j])
        return imgplot,
    
    ani = animation.FuncAnimation(fig,updatefig,frames=range(len(animationImageList)),interval=50,blit=True)

    #plt.plot(thrustCurve)
    plt.show()

if __name__ == "__main__":
    main()
