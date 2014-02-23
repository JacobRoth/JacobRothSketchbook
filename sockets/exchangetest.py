import sys

class MarketOrder:
    def __init__(self, user):
        self.user = user

class Ask(MarketOrder):
    def __init__(self,user,price,amount):
        MarketOrder.__init__(self,user)
        self.price=price #price of one coin
        self.amount = amount #coins to sell

class Bid(MarketOrder):
    def __init__(self,user,price,amount):
        MarketOrder.__init__(self,user)
        self.price=price
        self.amount = amount
        
class User:
    def __init__(self,name,coins,dollars): #just trying out 2 currencies right now
        self.name=name
        self.coins=coins
        self.dollars=dollars
        self.lockedForOperation = False # for thread safety
    def ask(self,exchange,price,amount): # sell off coins
        if (amount<= self.coins): #have enough. note, this needs to be repeated to the trade-reconcillation part too.
            exchange.asks.append(Ask(self,price,amount))
        else:
            print("not enough coins")

    def bid(self,exchange,price,amount):
        if (amount*price <= self.dollars):
            exchange.bids.append(Bid(self,price,amount))
    

class Exchange:
    def __init__(self):
        self.bids = []
        self.asks = [] 
    def seekAndSatisfy(self):
        for bid in self.bids:
            for ask in self.asks:
                if bid.price >= ask.price: #we're paying out the bid amount. That or we pocket the spread as a way of getting paid? I dont know
##                    print("ok, we found something")
                    amountBeingTraded = min(bid.amount,ask.amount) # so we dont oversell anybody
                    #safety checks
                    if ( (not ask.user.lockedForOperation) and (not bid.user.lockedForOperation)):
##                        print(amountBeingTraded)
##                        print("they are unlocked")
##                        print(ask.user)
##                        print(ask.user.coins)
##                        print(bid.user)
##                        print(bid.user.coins)
                        if ( (amountBeingTraded <= ask.user.coins) and (bid.price*amountBeingTraded <= bid.user.dollars)):
                            #all good
                            print("actually doing a trade now for " + str(amountBeingTraded) + " coins")
                            ask.user.lockedForOperation = True
                            bid.user.lockedForOperation = True
    
                            bid.user.coins += amountBeingTraded
                            ask.user.coins -= amountBeingTraded
                        
                            bid.user.dollars -= bid.price*amountBeingTraded
                            ask.user.dollars += bid.price*amountBeingTraded

                            ask.user.lockedForOperation = False
                            bid.user.lockedForOperation = False

def main():
    #some tests
    global ex
    ex = Exchange()
    global alice
    alice = User("Alice",2,2)
    global bob
    bob = User("Bob",20,20)
    alice.ask(ex,2,2)
    bob.bid(ex,3,2)
    ex.seekAndSatisfy()
    

if __name__=="__main__":
    main()
