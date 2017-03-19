" Time utils

function! time#IsDay()
  let l:daytime = 1
  if executable('php')
    let l:tz = 'date_default_timezone_set("Europe/Paris")'
    let l:now = 'date("H:i")'
    let l:sunrise = 'date_sunrise(time(), SUNFUNCS_RET_STRING, 48.8566, 2.3522, 96, intval(date("P", time())))'
    let l:sunset = 'date_sunset(time(), SUNFUNCS_RET_STRING, 48.8566, 2.3522, 96, intval(date("P", time())))'
    let l:php = printf("php -r '%s; echo (%s > %s) && (%s < %s);'", l:tz, l:now, l:sunrise, l:now, l:sunset)
    let l:daytime = system(l:php)
  elseif exists('*strftime')
    let l:time = strftime('%H') " %M
    let l:sunrise = 8
    let l:sunset = 20
    let l:daytime = l:time >= l:sunrise && l:time <= l:sunset
  endif
  return l:daytime
endfunction

function! time#IsNight()
  return !time#IsDay()
endfunction
