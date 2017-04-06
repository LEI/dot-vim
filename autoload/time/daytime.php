<?php

$timezone = 'Europe/Paris';

if (PHP_SAPI === 'cli') {
    if (count($argv) > 2) throw new \Exception('Too many arguments');
    if (count($argv) === 2) $timezone = $argv[1];
}

function isDayTime($dt, $lat, $lon) {
    $timestamp = $dt->getTimestamp(); // ->format('H:i')
    $format = SUNFUNCS_RET_TIMESTAMP; // _STRING, _DOUBLE, _TIMESTAMP
    $zenith = 96; // Civilian zenith
    $offset = $dt->getOffset() / 3600; // GMT offset
    $args = [$timestamp, $format, $lat, $lon, $zenith, $offset];
    $sunrise = call_user_func_array('date_sunrise', $args);
    $sunset = call_user_func_array('date_sunset', $args);
    return $timestamp > $sunrise && $timestamp < $sunset;
}

function main($tzName) {
    $tz = new DateTimeZone($tzName);
    $now = new DateTime('now', $tz);
    $loc = $tz->getLocation();
    $lat = $loc['latitude'];
    $lon = $loc['longitude'];
    return isDayTime($now, $lat, $lon);
}

exit(main($timezone));
