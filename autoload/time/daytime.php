<?php
/**
 * Check if the current time is day time.
 */

$timezone = 'Europe/Paris';
date_default_timezone_set($timezone);

if (PHP_SAPI === 'cli') {
    if (count($argv) > 2) {
        throw new \Exception('Too many arguments');
    }
    if (count($argv) === 2) {
        $timezone = $argv[1];
    }
}

function isDayTime($dt, $lat, $lon)
{
    $timestamp = $dt->getTimestamp(); // ->format('H:i')
    if (function_exists('date_sun_info')) {
        $sun_info = date_sun_info($timestamp, $lat, $lon);
        $sunrise = $sun_info['sunrise'];
        $sunset = $sun_info['sunset'];
    } else {
        $format = SUNFUNCS_RET_TIMESTAMP; // _STRING, _DOUBLE, _TIMESTAMP
        $zenith = 96; // Civilian zenith
        $offset = $dt->getOffset() / 3600; // GMT offset
        $args = [$timestamp, $format, $lat, $lon, $zenith, $offset];
        $sunrise = call_user_func_array('date_sunrise', $args);
        $sunset = call_user_func_array('date_sunset', $args);
    }
    return $timestamp > $sunrise && $timestamp < $sunset;
}

function main($timezone)
{
    $tz = new DateTimeZone($timezone);
    $now = new DateTime('now', $tz);
    $loc = $tz->getLocation();
    $lat = $loc['latitude'];
    $lon = $loc['longitude'];
    return isDayTime($now, $lat, $lon);
}

exit(main($timezone));
