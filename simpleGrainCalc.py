#simple manual-input grain calculator
import math
def simple(a = .104,n = .352,fuelDensity = 930,mDotOxTotal = 3.99,mDotFuelTotal = .616):
    numPorts = eval(input("number of equal ports: "))
    mDotOx = mDotOxTotal/numPorts
    mDotFuel = mDotFuelTotal/numPorts

    perimeter = eval(input("perimeter (one port) in cm: "))
    area = eval(input("area (one port) in cm^2: "))
    perimeter = perimeter/100
    area = area/(100*100)

    reqLen = mDotFuel / (a* .001 * ((mDotOx/area)**n) * fuelDensity * perimeter)

    print("Regression rate: " +str(a* .001 * ((mDotOx/area)**n)) + " m/s")
    print("Required Length: " +str(reqLen))

def circle(a = .104,n = .352,fuelDensity = 930,mDotOxTotal = 3.99,mDotFuelTotal = .616):
    numPorts = eval(input("number of equal ports: "))
    mDotOx = mDotOxTotal/numPorts
    mDotFuel = mDotFuelTotal/numPorts

    radius = eval(input("radius (one port) in cm: "))
    perimeter = math.pi*2*radius
    area = math.pi*radius*radius
    perimeter = perimeter/100
    area = area/(100*100)

    reqLen = mDotFuel / (a* .001 * ((mDotOx/area)**n) * fuelDensity * perimeter)

    print("Regression rate: " +str(a* .001 * ((mDotOx/area)**n)) + " m/s")
    print("Required Length: " +str(reqLen))

if __name__ == "__main__":
    while(1==1):
        circle(a=.1146,n=.5036,fuelDensity=915,mDotOxTotal=4.791,mDotFuelTotal=.737) #marielle's constants
        #simple()
