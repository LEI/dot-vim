" Color scheme plugins

" set background=dark
" colorscheme spacegray

" Pack 'ajh17/Spacegray.vim'
" Pack 'chriskempson/base16-vim'
" Pack 'jonathanfilip/vim-lucius'
" Pack 'jordwalke/flatlandia'
" Pack 'kristijanhusak/vim-hybrid-material'
" Pack 'NLKNguyen/papercolor-theme'
" Pack 'rakr/vim-one'
" Pack 'raphamorim/lucario'
" Pack 'whatyouhide/vim-gotham'

Pack 'lifepillar/vim-solarized8'
let g:true_color = 1

" nnoremap <silent> <F4> :<C-u>call Solarized8Contrast(-v:count1)<CR>
" nnoremap <silent> <F5> :call ToggleBackground()<CR>
" nnoremap <silent> <F6> :<C-u>call Solarized8Contrast(+v:count1)<CR>

augroup Solarized
  autocmd!
  " autocmd User Config call ColorScheme()
  "autocmd VimEnter * call ColorScheme()
  colorscheme solarized8

  " Quickfix PHP indentation issue (caused by 'hi clear' in colorscheme)
  " Similar to https://github.com/2072/PHP-Indenting-for-VIm/issues/52
  autocmd VimEnter * highlight link PhpParent Normal
augroup END

function! ColorScheme(...) abort
  let l:colors = a:0 ? a:1 : 'solarized8'
  let l:bg = a:0 > 1 ? a:2 : ''
  let l:theme = a:0 > 2 ? a:3 : ''
  if l:bg ==# ''
    let l:daytime = time#IsDay()
    if l:daytime != -1
      let l:bg = l:daytime ? 'light' : 'dark'
    else
      let l:bg = &background
    endif
  endif
  let l:colors_name = l:colors
        " \ . (strlen(l:bg) ? '_' . l:bg : '')
        \ . (strlen(l:theme) ? '_' . l:theme : '')
  " try
    let &background = l:bg
    execute 'colorscheme'  l:colors_name
  " catch /E185:/
  "   echoerr 'Cannot find color scheme: ' . l:colors_name
  " endtry
endfunction

function! Solarized8Contrast(delta) abort
  "let l:schemes = map(['_low', '_flat', '', '_high'], "'solarized8_'.(&background).v:val")
  let l:schemes = map(['_low', '_flat', '', '_high'], "'solarized8'.v:val")
  execute 'colorscheme' l:schemes[((a:delta+index(l:schemes, g:colors_name)) % 4 + 4) % 4]
endfunction

function! ToggleBackground(...) abort
  let l:background = &background
  let l:c = g:colors_name
  let l:b = l:background !=# 'dark' ? 'dark' : 'light'
  "if g:colors_name =~# l:background
  "  let l:c = substitute(l:c, l:background, l:b, '')
  "endif
  let &background = l:b
  execute 'colorscheme' l:c
endfunction

" Override cursor highlight group
function! CursorColor() abort
  if &background ==# 'dark'
    " highlight Cursor ctermfg=8 ctermbg=4 guifg=#002b36 guibg=#268bd2
    highlight Cursor ctermfg=0 ctermbg=15 guifg=#002b36 guibg=#fdf6e3
  else "if &background ==# 'light'
    " highlight Cursor ctermfg=15 ctermbg=4 guifg=#fdf6e3 guibg=#268bd2
    highlight Cursor ctermfg=15 ctermbg=0 guifg=#fdf6e3 guibg=#002b36
  endif
endfunction

augroup CustomColorcheme
  autocmd!
  autocmd VimEnter,ColorScheme * :call CursorColor()
augroup END
