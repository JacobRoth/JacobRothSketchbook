#!/usr/bin/python3

import socket

serversocket = socket.socket(socket.AF_INET,socket.SOCK_STREAM)

serversocket.bind(("localhost",4325))
serversocket.listen(5)
while True:
    (clientsocket,address) = serversocket.accept()
    print("detected connection from address: "+str(address))
    char = serversocket.recv(1)
    print(char)
