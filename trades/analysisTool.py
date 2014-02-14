#!/usr/bin/python3
import matplotlib,pylab

sourcefile = "fillmein.coindata"
numpyArray = pylab.loadtxt(sourceFile,delimiter=',')
timeAxis = []
coinPrice []
for iii in numpyArray:
    timeAxis.append(iii[0])
    coinPrice.append(iii[1])
