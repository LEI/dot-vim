" Color Scheme

" Plug 'altercation/vim-colors-solarized'
" colorscheme solarized
" call togglebg#map('<F5>')

" if exists('g:loaded_solarized8')
"   finish
" endif

Plug 'lifepillar/vim-solarized8'

nnoremap <F5> :call ToggleBackground()<CR>
nnoremap <F4> :<C-u>call Solarized8Contrast(-v:count1)<CR>
nnoremap <F6> :<C-u>call Solarized8Contrast(+v:count1)<CR>

augroup Colors
  autocmd!
  autocmd VimEnter * call SetColorScheme('solarized8_dark')
  autocmd VimEnter,ColorScheme * call Highlight(&background)
augroup END

" Custom highlight groups
function! Highlight(bg) abort
  if a:bg ==# 'dark'
    " highlight Cursor ctermfg=8 ctermbg=4 guifg=#002b36 guibg=#268bd2
    highlight Cursor ctermfg=0 ctermbg=15 guifg=#002b36 guibg=#fdf6e3
  elseif a:bg ==# 'light'
    " highlight Cursor ctermfg=15 ctermbg=4 guifg=#fdf6e3 guibg=#268bd2
    highlight Cursor ctermfg=15 ctermbg=0 guifg=#fdf6e3 guibg=#002b36
  endif
endfunction

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
    " call Highlight(&background)
  catch /E185:/ " echoerr 'Colorscheme not found: ' . l:colors_name
    " colorscheme default
  endtry
endfunction
