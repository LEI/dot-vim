" Time utils
"
" https://gist.github.com/alexander-yakushev/88531e23a89a0f2acbf1
" lua tonumber(os.date('%H'))

if exists('g:loaded_time')
  finish
endif

let g:loaded_time = 1
let g:time_zone = get(g:, 'time_zone', strlen($TZ) ? $TZ : 'Europe/Paris')

let s:dir = expand('<sfile>:p:h') " Not working for symlinks

function! time#IsDay()
  if executable('php')
    return s:IsDayTime_PHP()
  endif
  if exists('*strftime')
    return s:IsDayTime()
  endif
  return -1
endfunction

function! time#IsNight()
  return !time#IsDay()
endfunction

function! s:IsDayTime()
  let l:time = strftime('%H%M')
  let l:sunrise = 700
  let l:sunset = 2000
  return l:time > l:sunrise && l:time < l:sunset
endfunction

function! s:IsDayTime_PHP()
  let l:file = s:dir . '/time/daytime.php'
  if filereadable(l:file)
    let l:cmd = 'php ' . l:file . ' ' . g:time_zone
    return system(l:cmd)
  endif
endfunction
