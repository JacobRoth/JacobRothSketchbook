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
    while True:
        data = conn.recv(1024)
        if not data: break
        os.system("useradd "+str(data.decode()))
    conn.close()
