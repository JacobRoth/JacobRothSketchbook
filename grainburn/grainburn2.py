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

def returnDistanceArray(mask):
    #remember, in the mask 1 is nitrous/bore, and 0 is fuel
    returnMe = np.zeros(mask.shape)
    columns,rows = mask.shape
    for row in range(rows-1):
        for column in range(columns-1):
            if mask[row][column] == 1: #we're analyzing a bore space. just write 0 and fughettaboutit
                returnMe[row][column] = 0
                #print(row,column,"bore!")
            else:
                #print(row,column,"fuel!")
                squaredFurthestAway = 10000000000 # large
                #we have just selected a square in returnme
                for rrr in range(rows-1):
                    for ccc in range(columns-1):
                        if mask[rrr][ccc] == 1:
                            distSquared = (rrr-rows)*(rrr-rows) + (ccc-columns)*(ccc-columns)
                
                            if distSquared < squaredFurthestAway:
                                squaredFurthestAway = distSquared
                returnMe[row][column] = math.sqrt(squaredFurthestAway)
                #print(returnMe[row][column])
    return np.copy(returnMe)
                    
            

def main():
    global mask
    global fuelgrain
    global size
    mask=mpimg.imread('tinergrain.png')
    size,scratch = mask.shape
    if size != scratch:
        print("error error - that image is not square. I can't work with that.")
        print("please have image width equal image height exactly")
    fuelgrain = returnDistanceArray(mask)
    imgplot=plt.imshow(fuelgrain)

if __name__ == "__main__":
    main()
