#simple manual-input grain calculator

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


if __name__ == "__main__":
    while(1==1):
        #simple(a=.1146,n=.5036,fuelDensity=739.2405,mDotOxTotal=3.81818,mDotFuelTotal=.58777) #marielle's constants
        simple()
