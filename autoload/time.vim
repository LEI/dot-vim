" Time utils

let g:timezone = get(g:, 'timezone', strlen($TZ) ? $TZ : 'Europe/Paris')

function! time#IsDay()
  let l:daytime = 1
  if executable('php')
    let l:cmd = '$dt = new DateTime();'
    let l:cmd.= '$tz = new DateTimeZone("' . g:timezone . '");'
    " let l:cmd.= 'date_default_timezone_set($tz->getName());'
    let l:cmd.= '$dt = $dt->setTimezone($tz);' " $dt->getTimezone()
    let l:cmd.= '$loc = $tz->getLocation();'
    let l:cmd.= '$lat = $loc["latitude"];'
    let l:cmd.= '$lon = $loc["longitude"];'
    let l:cmd.= '$zen = 96;' " Civilian zenith
    let l:cmd.= '$off = $dt->getOffset() / 3600;'
    let l:cmd.= '$time = $dt->getTimestamp();'
    let l:cmd.= '$sunrise = date_sunrise($time, SUNFUNCS_RET_TIMESTAMP, $lat, $lon, $zen, $off);'
    let l:cmd.= '$sunset = date_sunset($time, SUNFUNCS_RET_TIMESTAMP, $lat, $lon, $zen, $off);'
    " let l:cmd.= '$now = $dt->format("H:i");' " SUNFUNCS_RET_STRING
    let l:cmd.= 'exit($time > $sunrise && $time < $sunset);'
    let l:daytime = system(printf("php -r '%s'", l:cmd)) == 1
  elseif exists('*strftime')
    let l:time = strftime('%h%M')
    let l:sunrise = 700
    let l:sunset = 2000
    let l:daytime = l:time > l:sunrise && l:time < l:sunset
  endif
  return l:daytime
endfunction

function! time#IsNight()
  return !time#IsDay()
endfunction
