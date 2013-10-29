import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
import random
import math

def convertDown(image):
    rows,columns,_ = image.shape
    bufferedImage=np.eye(rows,columns)
    for row in range(0,rows-1):
        for column in range(0,columns-1):
            if image[row][column].all()==0:
                bufferedImage[row][column] = 0 # fuel
            else:
                bufferedImage[row][column] = 1 # chamber
                
    return np.copy(bufferedImage)

def scopeGrain():
    for row in range(0,rows-1):
            for column in range(0,columns-1):
                if fuelgrain[row][column] == 1: # we found chamber!
                    pass
                else:
                    pass
                    '''# we're analyzing fuel
                    #let's analyze this for the nearest None (chamber) pixel
                    distanceToChamber = 10000000000000 # arbitrarily large
                    for rrr in range(0,rows-1):
                        for ccc in range(0,columns-1):
                            if fuelgrain[rrr][ccc] is None:
                                sqrtMe = (ccc-column)*(ccc-column) + (rrr-row)*(rrr-row)
                                distanceCurrent = math.sqrt( sqrtMe)
                                if distanceCurrent < distanceToChamber:
                                    distanceToChamber = distanceCurrent
                    fuelgrain[row][column] = distanceToChamber'''


def main():
    global fuelgrain
    fuelgrain = convertDown(mpimg.imread('samplegrain.png'))
    global rows,columns
    rows,columns = fuelgrain.shape
    
    #scopeGrain()

    fig,ax = plt.subplots()
    imgplot = plt.imshow(fuelgrain)

    plt.show()

if __name__=="__main__":
    main()

#x = input(">")

