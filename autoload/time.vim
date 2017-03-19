" Time utils

function! time#IsDay()
  let l:daytime = 1
  " if executable('php') " php -r date('H:i')
  "   " let l:daytime = system("php -r \"echo time() > date_sunrise(time(), SUNFUNCS_RET_TIMESTAMP) && time() < date_sunset(time(), SUNFUNCS_RET_TIMESTAMP);\"")
  "   echom system("php -r \"date_default_timezone_set('Europe/Paris'); echo date('H:i') .'/'. date_sunrise(time()) .'/'. date_sunset(time());\"")
  if exists('*strftime')
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
