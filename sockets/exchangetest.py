class MarketOrder:
    def __init__(self, user):
        self.user = user

class Ask(MarketOrder):
    def __init__(self,user,price):
        super(self,user)
        self.price=price

class Bid(MarketOrder):
    def __init__(self,user,price):
        MarketOrder.__init__(self,user)
        self.price=price
        
class User:
    def __init__(self,name,coins,dollars): #just trying out 2 currencies right now
        self.name=name
        self.coins=coins
        self.dollars=dollars
    

class Exchange:
    def __init__(self):
        self.bids = []
        self.asks = [] 
    def seekAndSatisfy(self):
        for bid in self.bids:
            for ask in self.asks:
                if bid>=ask:
                    
