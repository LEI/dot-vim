" Colorscheme

" Plug 'altercation/vim-colors-solarized'
" colorscheme solarized
" call togglebg#map('<F5>')

Plug 'lifepillar/vim-solarized8'

nnoremap <F5> :call ToggleBackground()<CR>
nnoremap <F4> :<C-u>call Solarized8Contrast(-v:count1)<CR>
nnoremap <F6> :<C-u>call Solarized8Contrast(+v:count1)<CR>

function! ToggleBackground(...) abort
  if g:colors_name =~# 'dark'
    let l:c = substitute(g:colors_name, 'dark', 'light', '')
  else
    let l:c = substitute(g:colors_name, 'light', 'dark', '')
  endif
  execute 'colorscheme' l:c
endfunction

function! Solarized8Contrast(delta) abort
  let l:schemes = map(['_low', '_flat', '', '_high'], '"solarized8_".(&background).v:val')
  exe 'colorscheme' l:schemes[((a:delta+index(l:schemes, g:colors_name)) % 4 + 4) % 4]
endfunction

function! SetColorScheme(...) abort
  let l:colors = a:0 ? a:1 : 'default'
  let l:theme = a:0 > 1 ? a:2 : ''
  let l:background = 'dark'
  if exists('*strftime')
    let s:hour = strftime('%H')
    if s:hour > 7 && s:hour < 20
      let l:background = 'light'
    endif
  endif
  let &background = l:background
  let l:colors_name = l:colors . (strlen(l:theme) ? '_' . l:theme : '')
  try
    execute 'colorscheme'  l:colors_name
  catch /E185:/ " echoerr 'Colorscheme not found: ' . l:colors_name
    " colorscheme default
  endtry
endfunction

augroup Colors
  autocmd!
  autocmd VimEnter * call SetColorScheme('solarized8_dark')
augroup END
