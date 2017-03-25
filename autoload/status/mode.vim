" Get the current mode and update SatusLine highlight group
function! status#mode#name(...) abort
  if status#Hide('mode')
    return ''
  endif
  let l:mode =  a:0 ? a:1 :mode()
  if g:statusline.winnr != winnr()
    let l:mode = 'nc'
  endif
  " if l:mode ==# 'n'
  "   highlight! link StatusLine StatusLineNormal
  " elseif l:mode ==# 'i'
  "   highlight! link StatusLine StatusLineInsert
  " elseif l:mode ==# 'R'
  "   highlight! link StatusLine StatusLineReplace
  " elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# '^V'
  "   highlight! link StatusLine StatusLineVisual
  " endif
  return get(g:statusline.modes, l:mode, l:mode)
endfunction

function! status#mode#highlight(...) abort
  let l:im = a:0 ? a:1 : ''
  " let l:im = a:0 ? a:1 : v:insertmode
  if l:im ==# 'i' " Insert mode
    highlight! link StatusLine StatusLineInsert
  elseif l:im ==# 'r' " Replace mode
    highlight! link StatusLine StatusLineReplace
  elseif l:im ==# 'v' " Virtual replace mode
    highlight! link StatusLine StatusLineReplace
  elseif strlen(l:im) > 0
    echoerr 'Unknown mode: ' . l:im
  else
    highlight link StatusLine NONE
  endif
endfunction
