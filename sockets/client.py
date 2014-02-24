import socket,os

HOST = 'localhost'
PORT = 4325

# the plan here is that this will be a dumb untrusted client that does this:

# print MOTD/instructions
# prompt for login or register
# if register:
#    get name, password*s*, textual captcha if that's a thing
#    send_text("register "+name+" "+str(hash(pass))
#    print( "you should be registered now, 


# if login:
#    prompt for name and pass, STORE THEM LOCALLY (VARS IN THIS SCRIPT)
#    more specifically, hash the password
#    send name+hash(pass)+"checklogin"
#    server returns if you're logged in.
#    while (True):
#       promt command
#       send name+hash(pass)+command
#       print response

# there will be no "logins"

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
