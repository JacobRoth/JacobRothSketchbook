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

def populatePointsListDumb(pointsList, image): # dumb version, no edge detection\
    #remember, in the image 1 is nitrous/bore, and 0 is fuel
    rows,columns = image.shape
    for row in range(0,rows-1):
        for column in range(0,columns-1):
            if image[row][column] == 1: #nitrous, add an expandcircle here
                pointsList.append( (row,column) )
            

def main():

    global pointsList
    global fuelgrain
    
    pointsList = [] # indexed as row,column (backwards) because that's how MATPLOTLIB rolls
    fuelgrain = mpimg.imread('tinergrain.png')

    populatePointsListDumb(pointsList,fuelgrain)
    
    size,scratch = fuelgrain.shape
    if size != scratch:
        print("error error - that image is not square. I can't work with that.")
        print("please have image width equal image height exactly")
    
    imgplot=plt.imshow(fuelgrain)

if __name__ == "__main__":
    main()
