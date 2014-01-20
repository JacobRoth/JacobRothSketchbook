<?php

	function bter_query($path, array $req = array()) {
		// API settings, add your Key and Secret at here
		$key = 'A2682749-3893-44C9-BA82-CCB0E1E4EEC0';
		$secret = '945b0766c4e4c4c37311af69f0426c5f86a7a39b4835a1dce7e312ecff3943aa';
	 
		// generate a nonce to avoid problems with 32bits systems
		$mt = explode(' ', microtime());
		$req['nonce'] = $mt[1].substr($mt[0], 2, 6);
	 
		// generate the POST data string
		$post_data = http_build_query($req, '', '&');
		$sign = hash_hmac('sha512', $post_data, $secret);
	 
		// generate the extra headers
		$headers = array(
			'KEY: '.$key,
			'SIGN: '.$sign,
		);


		// curl handle (initialize if required)
		static $ch = null;
		if (is_null($ch)) {
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			curl_setopt($ch, CURLOPT_USERAGENT, 
				'Mozilla/4.0 (compatible; Bter PHP bot; '.php_uname('a').'; PHP/'.phpversion().')'
				);
		}
		curl_setopt($ch, CURLOPT_URL, 'https://bter.com/api/'.$path);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
		curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
		

		var_dump("--------trying to get the curl code out");
		echo(curl_getinfo($ch, CURLINFO_EFFECTIVE_URL));
		echo("\n");
		echo(curl_getinfo($ch, CURLINFO_HTTP_CODE));
		echo("\n");
		var_dump("----------");

		// run the query
		$res = curl_exec($ch);

		if ($res === false) throw new Exception('Curl error: '.curl_error($ch));
		//echo $res;
		$dec = json_decode($res, true);
		if (!$dec) throw new Exception('Invalid data: '.$res);
		return $dec;
	}
	 
	 function get_top_rate($pair, $type='BUY') {
		$rate = 0;

		// our curl handle (initialize if required)
		static $ch = null;
		if (is_null($ch)) {
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			curl_setopt($ch, CURLOPT_USERAGENT, 
				'Mozilla/4.0 (compatible; Bter PHP bot; '.php_uname('a').'; PHP/'.phpversion().')'
				);
		}
		curl_setopt($ch, CURLOPT_URL, 'https://bter.com/api/1/depth/'.$pair);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);

		// run the query

		/*var_dump("--------trying to get the curl code out");
		echo(curl_getinfo($ch, CURLINFO_EFFECTIVE_URL));
		echo("\n");
		echo(curl_getinfo($ch, CURLINFO_HTTP_CODE));
		echo("\n");
		var_dump("----------");*/

		$res = curl_exec($ch);
		if ($res === false) throw new Exception('Could not get reply: '.curl_error($ch));
		//echo $res;
		$dec = json_decode($res, true);
		if (!$dec) throw new Exception('Invalid data: '.$res);
		
		if (strtoupper($type) == 'BUY') {
			$r =  $dec['bids'][0];
			$rate = $r[0];
		} else  {
			$r = end($dec['asks']);
			$rate = $r[0];
		}

		return $rate;
	}


	try {
		// example 1: get funds
		var_dump(bter_query('1/private/getfunds'));
		
		/*	
		// example 2: place a buy order
		$pair = 'ltc_btc';
		$type = 'buy';
		$rate = get_top_rate($pair, $type) * 1.01;
		var_dump($rate);
		var_dump(bter_query('1/private/placeorder', 
			array(
				'pair' => "$pair",
				'type' => "$type",
				'rate' => "$rate",
				'amount' => '0.01',
				)
			  )
			);
		
		// example 3: cancel an order
		var_dump(bter_query('1/private/cancelorder', array('order_id' => 125811)));
		
		// example 4: get order status
		var_dump(bter_query('1/private/getorder', array('order_id' => 15088)));

		//example 5: list all open orders
		var_dump(bter_query('1/private/orderlist'));
		*/

	} catch (Exception $e) {
		echo "Error:".$e->getMessage();
		
	} 
?> 
