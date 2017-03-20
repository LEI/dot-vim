" Color scheme plugins

" set background=dark
" colorscheme spacegray

" Plug 'ajh17/Spacegray.vim'
" Plug 'chriskempson/base16-vim'
" Plug 'jonathanfilip/vim-lucius'
" Plug 'jordwalke/flatlandia'
" Plug 'kristijanhusak/vim-hybrid-material'
" Plug 'morhetz/gruvbox'
" Plug 'NLKNguyen/papercolor-theme'
" Plug 'raphamorim/lucario'
" Plug 'whatyouhide/vim-gotham'

" Plug 'altercation/vim-colors-solarized'
" call togglebg#map('<F5>')

Plug 'lifepillar/vim-solarized8'

nnoremap <silent> <F4> :<C-u>call Solarized8Contrast(-v:count1)<CR>
nnoremap <silent> <F5> :call ToggleBackground()<CR>
nnoremap <silent> <F6> :<C-u>call Solarized8Contrast(+v:count1)<CR>

augroup Solarized
  autocmd!
  autocmd User Init if exists('*Solarized8') | call Solarized8() | endif
augroup END

" call Solarized8('solarized8', 'dark')
" call Solarized8('solarized8', 'light', 'flat')
function! Solarized8(...) abort
  let l:colors = a:0 ? a:1 : 'solarized8'
  let l:bg = a:0 > 1 ? a:2 : ''
  let l:theme = a:0 > 2 ? a:3 : ''
  let l:daytime = time#IsDay()
  if l:daytime != -1
    let l:bg = l:daytime ? 'light' : 'dark'
  elseif l:bg ==# ''
    let l:bg = &background
  endif
  let l:colors_name = l:colors
        \ . (strlen(l:bg) ? '_' . l:bg : '')
        \ . (strlen(l:theme) ? '_' . l:theme : '')
  " try
  let &background = l:bg
  execute 'colorscheme'  l:colors_name
  " catch /E185:/
  "   echoerr 'Cannot find color scheme: ' . l:colors_name
  "   colorscheme default
  " endtry
endfunction

function! Solarized8Contrast(delta) abort
  let l:schemes = map(['_low', '_flat', '', '_high'], "'solarized8_'.(&background).v:val")
  execute 'colorscheme' l:schemes[((a:delta+index(l:schemes, g:colors_name)) % 4 + 4) % 4]
endfunction

function! ToggleBackground(...) abort
  let l:background = &background
  let l:c = g:colors_name
  let l:b = l:background !=# 'dark' ? 'dark' : 'light'
  if g:colors_name =~# l:background
    let l:c = substitute(l:c, l:background, l:b, '')
  endif
  let &background = l:b
  execute 'colorscheme' l:c
endfunction
