import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np

def convertDown(image):
    rows,columns,_ = image.shape
    bufferedImage=np.eye(rows,columns)
    for row in range(0,rows-1):
        for column in range(0,columns-1):
            if image[row][column].all()==0:
                bufferedImage[row][column] = 0
            else:
                bufferedImage[row][column] = 1
            

    

    return np.copy(bufferedImage)


def burnOneLayer(image):
    numburned=0
    rows,columns = image.shape
    bufferedImage=np.copy(image)

    for row in range(1,rows-2): # we're not going to burn the edges
        for column in range(1,columns-2):
            if image[row][column]==0:
                #it's fuel
                if image[row-1][column]==1 or image[row+1][column]==1 or image[row][column-1]==1 or image[row][column+1]==1:

#or image[row-1][column-1]==1 or image[row-1][column+1]==1 or image[row+1][column-1]==1 or image[row+1][column+1]==1: # there is a nitrous touching it
                    bufferedImage[row][column]=1 #will become nitrous when image is copied over
                    numburned = numburned+1
#                    print("ZOMG burned one")
    return np.copy(bufferedImage),numburned

    #von Rossum be praised for the Python garbage collector
    


fuelgrain =convertDown(mpimg.imread('samplegrain.png'))
for i in range(0,40):
    fuelgrain,n = burnOneLayer(fuelgrain)
    print(n)

fig,ax = plt.subplots()
imgplot = plt.imshow(fuelgrain)

plt.show()

#x = input(">")

