" Time utils

let g:timezone = get(g:, 'timezone', strlen($TZ) ? $TZ : 'Europe/Paris')

function! time#IsDay()
  return s:daytime()
endfunction

function! time#IsNight()
  return !s:daytime()
endfunction

function! s:daytime()
  if executable('php')
    return s:php_daytime()
  endif
  if exists('*strftime')
    return s:vim_daytime()
  endif
  return -1
endfunction

function! s:php_daytime()
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
  return system(printf("php -r '%s'", l:cmd)) == 1
endfunction

function! s:vim_daytime()
  let l:time = strftime('%h%M')
  let l:sunrise = 700
  let l:sunset = 2000
  return l:time > l:sunrise && l:time < l:sunset
endfunction
