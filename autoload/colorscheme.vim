" Color Scheme

" Defaults:
let s:colors = 'default'
let s:background = 'dark'
let s:theme = ''

function! s:bg() abort
  let l:bg = 'dark'
  if exists('*strftime')
    let s:hour = strftime('%H')
    if s:hour > 7 && s:hour < 20
      let l:bg = 'light'
    endif
  endif
  return l:bg
endfunction

function! colorscheme#Set(...) abort
  let l:colors = a:0 ? a:1 : s:colors
  let l:bg = a:0 > 1 ? a:2 : s:bg()
  let l:theme = a:0 > 2 ? a:3 : s:theme
  let l:colors_name = l:colors
        \ . (strlen(l:bg) ? '_' . l:bg : '')
        \ . (strlen(l:theme) ? '_' . l:theme : '')
  echom 'USING: ' . l:colors_name
  let &background = l:bg
  execute 'colorscheme'  l:colors_name
  " try
  " catch /E185:/
  "   echoerr 'Cannot find color scheme: ' . l:colors_name
  "   colorscheme default
  " endtry
endfunction

function! colorscheme#ToggleBackground(...) abort
  if g:colors_name =~# 'dark'
    let l:c = substitute(g:colors_name, 'dark', 'light', '')
  else
    let l:c = substitute(g:colors_name, 'light', 'dark', '')
  endif
  execute 'colorscheme' l:c
endfunction
