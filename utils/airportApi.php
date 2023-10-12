<?php
require '../vendor/autoload.php';
use GuzzleHttp\Client;

$client = new Client();
$response = $client->request('GET', 'https://world-airports-directory.p.rapidapi.com/v1/airports/Sfax?page=1&limit=20&sortBy=AirportName%3Aasc', [
	'headers' => [
		'X-RapidAPI-Host' => 'world-airports-directory.p.rapidapi.com',
		'X-RapidAPI-Key' => '2f41b0ca1dmsh71f33c5a756a669p1a159ajsn52c538eb81ba',
	],
]);

echo $response->getBody();
?>