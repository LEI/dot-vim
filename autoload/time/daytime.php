<?php

$tzName = 'Europe/Paris';

if (PHP_SAPI === 'cli') {
    if (count($argv) > 2) throw new \Exception('Too many arguments');
    if (count($argv) === 2) $tzName = $argv[1];
}

$timeZone = new DateTimeZone($tzName);
$location = $timeZone->getLocation();
$latitude = $location['latitude'];
$longitude = $location['longitude'];

$dateTime = new DateTime('now', $timeZone);

$timestamp = $dateTime->getTimestamp(); // ->format('H:i');
$format = SUNFUNCS_RET_TIMESTAMP; // STRING, DOUBLE, TIMESTAMP
$zenith = 96; // Civilian zenith
$offset = $dateTime->getOffset() / 3600; // GMT offset

$args = [$timestamp, $format, $latitude, $longitude, $zenith, $offset];

$sunrise = call_user_func_array('date_sunrise', $args);
$sunset = call_user_func_array('date_sunset', $args);

$isDayTime = $timestamp > $sunrise && $timestamp < $sunset;

exit($isDayTime);
