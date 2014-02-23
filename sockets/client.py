import socket,os

HOST = 'localhost'
PORT = 4325

def send_text(text): #returns the response from the server
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((HOST,PORT))
    transmission = bytes(text,'UTF-8')
    s.send(transmission)
    
    #conn, addr = s.accept()
    data = None
    while not data:
        data = s.recv(4096)
    print(data.decode('UTF-8'))
    
    s.close()

while (True):
    send_text(input("? "))
