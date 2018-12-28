<?php
$ch = curl_init();
$url="http://i.http-mesh-test.weibo.com/";

// $proxy="10.211.55.5:8080";
// curl_setopt($ch, CURLOPT_PROXY, $proxy);

curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_VERBOSE, 1);
curl_setopt($ch, CURLOPT_TIMEOUT,1);
$res = curl_exec($ch);
file_put_contents(sprint_r($res), "./http-client.out");
curl_close($ch); 
