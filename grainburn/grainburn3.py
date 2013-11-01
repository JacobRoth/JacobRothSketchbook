#/usr/bin/env python
print("hello world")
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
import math

def convertDown(image): # do not use on grayscale image
    rows,columns,_ = image.shape
    bufferedImage=np.eye(rows,columns)
    for row in range(0,rows-1):
        for column in range(0,columns-1):
            bufferedImage[row][column]=image[row][column].any() # returns TRUE if any values are not equal to zero, IE, square is not true black
                
    return np.copy(bufferedImage)

#def populatePointsListDumb(pointsList, image): # dumb version, no edge detection\
#    #remember, in the image 1 is nitrous/bore, and 0 is fuel
#    rows,columns = image.shape
#    for row in range(0,rows-1):
#        for column in range(0,columns-1):
#            if image[row][column] == 1: #nitrous, add an expandcircle here
#                pointsList.append( (row,column) )

def populatePointsListSmart(pointsList, image): #adds edge detection, making the pointsList much shorter but still definitive
    #remember, in the image 1 is nitrous/bore, and 0 is fuel
    rows,columns = image.shape
    for row in range(0,rows-1):
        for column in range(0,columns-1):
            if image[row][column] == 1: #nitrous
                addCircle = False

                #these are all run with try: statements because sometimes we will attempt to analyze a square that does not exist. 
                try:
                    if image[row][column-1] == 0: #touching a fuel square, so we are on the edge
                        addCircle = True
                except:
                    pass #dont bother, just move on to analyzing the next square

                try:
                    if image[row][column+1] == 0: #touching a fuel square, so we are on the edge
                        addCircle = True
                except:
                    pass #dont bother, just move on to analyzing the next square
                
                try:
                    if image[row-1][column] == 0: #touching a fuel square, so we are on the edge
                        addCircle = True
                except:
                    pass #dont bother, just move on to analyzing the next square

                try:
                    if image[row+1][column] == 0: #touching a fuel square, so we are on the edge
                        addCircle = True
                except:
                    pass #dont bother, just move on to analyzing the next square
                        
                if addCircle == True:
                    pointsList.append( (row,column) )

def drawCircleOnGrain(pointTuple,radius,fuelgrain):
    rSquared = radius*radius
    for row in range(pointTuple[0]-radius, pointTuple[0]+radius):
        for column in range(pointTuple[1]-radius, pointTuple[1]+radius):
            if (pointTuple[0]-row)**2 + (pointTuple[1]-column)**2 < rSquared:
                try:
                    fuelgrain[row][column] = 1 # make it nitrous
                    #print("made nitrous")
                except:
                    pass # must have tried to access a nonexistent (out of bounds) pixel

def main():

    global pointsList
    global fuelgrain
    
    pointsList = [] # indexed as row,column (backwards) because that's how MATPLOTLIB rolls
    fuelgrain = mpimg.imread('tinygrain.png')
    
    size,scratch = fuelgrain.shape
    if size != scratch:
        print("error error - that image is not square. I can't work with that.")
        print("please have image width equal image height exactly")
        return "err - nonsquare image"

    populatePointsListSmart(pointsList ,fuelgrain)

    regression = 20
    for iteration in range(0,regression):
        for myTuple in pointsList:
            drawCircleOnGrain(myTuple,iteration,fuelgrain)

    
    imgplot=plt.imshow(fuelgrain)
    imgplot.set_cmap("gray") # sets the correct color scheme
    plt.show()
    

if __name__ == "__main__":
    main()
