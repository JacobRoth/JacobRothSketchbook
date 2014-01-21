bter-api
========

This library provides a wrapper (hopefully a convenient one) around the public
and trading APIs of the bter.com exchange site.  So that you don't have to
spend your time chasing down wacky dependencies, it depends only on the
following standard libraries that are "batteries included" with a Python 2.7
installation: 

    datetime, decimal, hashlib, hmac, HTMLParser, httplib, json, urllib, warnings

NOTE: bter.com is not affiliated with this project; this is a completely independent
implementation based on the API description.  Use at your own risk.

If you find the library useful and would like to donate (and many thanks to 
those that have donated!), please send some coins here:

    LTC LdP6HA2jtGQhwVfMMRWGyTR98CdthgKhXv
    BTC 1NjwSFTEXZ5SRjAoUY7ihnAZnAeFB6NP9X

This library is heavily based off alanmcintyre's btce-api
(https://github.com/alanmcintyre/btce-api) for btc-e.com. Alan deserves most of the
credit for this and his donation addresses can be found in the btce-api readme.


The following functions in the bterapi module access the public API and do not
require any user account  information:

    getDepth(pair) - Retrieves the depth for the given pair.  Returns a tuple
    (asks, bids); each of these is a list of (price, volume) tuples.

    getTradeHistory(pair[, tid]) - Retrieves the trade history for the given pair.
    Returns a list of Trade instances.  Each Trade instance has the following members:
        pair,
        type ('buy or sell'),
        price,
        tid,
        amount, and
        date (a datetime object).
    Optional input argument tid returns trades starting from transaction with id tid.

The TradeAPI class in the bterapi module accesses the trading API, and requires
the key and secret values (found in a link on the bter.com API page).

The following methods are available on a TradeAPI instance:

    getFunds() - Retrieves basic account information via the server getfunds url, and
    returns a dict of dicts. First level is currencies, second layer is 'available'
    and 'locked'.

    getOrderStatus(order) - Retrieves an order via the server getorder url, and
    returns an OrderItem object, which has the following members:
        order_id,
        status ('open' or 'closed'),
        pair,
        type ('buy' or 'sell'),
        rate,
        amount (amount remaining to be traded),
        initial_rate,
        initial_amount,
    Input order can be either an OrderItem object or an order id.

    placeOrder(pair, type, rate, amount, [update_delay=]) - Places a trade order via
    the server placeorder url,and return an OrderItem object. If update_delay is
    passed, will wait update_delay seconds then retrieve the order status, allowing
    to fill in more members of the OrderItem such as its status.

    cancelOrder(order) - Cancels the specified order via the server cancelorder url,
    and returns the message passed by the server. Input order can be an OrderItem or
    an order id.
    
    All methods also take an optional error_handler input. This should be a function
    which takes the server output as an input and either raises an exception or
    returns the server output (potentially modified). It is only called if the server
    indicates a problem. You can use this function to ignore certain errors; default
    behavior is to raise an exception for any error returned from the server.

For more information on the inputs and ouputs to these functions, see the bter API
documentation (http://bter.com/api). For usage examples, see alanmcintyre's btce-api
(https://github.com/alanmcintyre/btce-api) which has very similar usage and includes
samples.
