#!/usr/bin/python3
# server that creates a system user
# just to test

import socket,os

HOST = 'localhost'                 # Symbolic name meaning all available interfaces
PORT = 4325              # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(5)
while True:
    conn, addr = s.accept()
    print('Connected by', addr)
    data = None
    while not data:                #wait until we get something
        data = conn.recv(4096)     #receive ALL the bytes.
    print(data.decode('UTF-8'))
    conn.send(b'some response bytes')
    
    conn.close()
