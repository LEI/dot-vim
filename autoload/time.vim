" Time utils

let g:timezone = get(g:, 'timezone', 'Europe/Paris')

function! time#IsDay()
  let l:daytime = 1
  if executable('php')
    let l:vars = '$dt = new DateTime();'
    let l:vars.= '$tz = new DateTimeZone("' . g:timezone . '");'
    " let l:vars.= 'date_default_timezone_set($tz->getName());'
    let l:vars.= '$dt = $dt->setTimezone($tz);' " $dt->getTimezone()
    let l:vars.= '$loc = $tz->getLocation();'
    let l:vars.= '$lat = $loc["latitude"];'
    let l:vars.= '$lon = $loc["longitude"];'
    let l:vars.= '$zen = 96;' " Civilian zenith
    let l:vars.= '$off = $dt->getOffset() / 3600;'
    let l:vars.= '$time = $dt->getTimestamp();'
    let l:vars.= '$sunrise = date_sunrise($time, SUNFUNCS_RET_TIMESTAMP, $lat, $lon, $zen, $off);'
    let l:vars.= '$sunset = date_sunset($time, SUNFUNCS_RET_TIMESTAMP, $lat, $lon, $zen, $off);'
    " let l:vars.= '$now = $dt->format("H:i");' " SUNFUNCS_RET_STRING
    let l:php = printf("php -r '%s; echo $time > $sunrise && $time < $sunset;'", l:vars)
    let l:daytime = system(l:php)
  elseif exists('*strftime')
    let l:time = strftime('%h%M')
    let l:sunrise = 700
    let l:sunset = 2000
    let l:daytime = l:time > l:sunrise && l:time < l:sunset
  endif
  return l:daytime == 1
endfunction

function! time#IsNight()
  return !time#IsDay()
endfunction
