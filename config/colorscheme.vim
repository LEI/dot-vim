" Color scheme config

" colorscheme solarized
" call togglebg#map('<F5>')

call colorscheme#Set('solarized8')

nnoremap <silent> <F4> :<C-u>call Solarized8Contrast(-v:count1)<CR>
nnoremap <silent> <F5> :call ToggleBackground()<CR>
nnoremap <silent> <F6> :<C-u>call Solarized8Contrast(+v:count1)<CR>

function! ToggleBackground(...) abort
  if g:colors_name =~# 'dark'
    let l:c = substitute(g:colors_name, 'dark', 'light', '')
  else
    let l:c = substitute(g:colors_name, 'light', 'dark', '')
  endif
  execute 'colorscheme' l:c
endfunction

function! Solarized8Contrast(delta) abort
  let l:schemes = map(['_low', '_flat', '', '_high'], "'solarized8_'.(&background).v:val")
  execute 'colorscheme' l:schemes[((a:delta+index(l:schemes, g:colors_name)) % 4 + 4) % 4]
endfunction
