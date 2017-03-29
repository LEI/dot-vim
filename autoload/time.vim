" Time utils

if exists('g:loaded_time')
  finish
endif

let s:dir = expand('<sfile>:p:h') " Not working for symlinks

let g:loaded_time = 1

let g:timezone = get(g:, 'timezone', strlen($TZ) ? $TZ : 'Europe/Paris')

function! time#IsDay()
  if executable('php')
    return s:php_daytime()
  endif
  if exists('*strftime')
    return s:daytime()
  endif
  return -1
endfunction

function! time#IsNight()
  return !time#IsDay()
endfunction

function! s:daytime()
  let l:time = strftime('%H%M')
  let l:sunrise = 700
  let l:sunset = 2000
  return l:time > l:sunrise && l:time < l:sunset
endfunction

function! s:php_daytime()
  let l:file = s:dir . '/time/daytime.php'
  if filereadable(l:file)
    let l:cmd = 'php ' . l:file . ' ' . g:timezone
    return system(l:cmd)
  endif
endfunction
