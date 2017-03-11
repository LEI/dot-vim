" Colorscheme

" Plug 'LEI/flattened'
" Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'

function! s:colorscheme(...)
  let l:colors = a:0 ? a:1 : 'solarized8'
  let l:theme = a:0 > 1 ? a:2 : 'flat'
  let l:bg = 'dark'
  if exists('*strftime')
    let s:hour = strftime('%H')
    if s:hour > 7 && s:hour < 20
      let l:bg = 'light'
    endif
  endif
  try
    let &background = l:bg
    " execute 'colorscheme flattened_' . l:bg
    execute 'colorscheme ' . l:colors . '_' . l:bg . (l:theme ? '_' . l:theme : '')
  catch /E185:/
    " colorscheme default
  endtry
  " colorscheme solarized
  " call togglebg#map('<F5>')
endfunction

augroup Colors
  autocmd!
  autocmd VimEnter * call s:colorscheme()
augroup END
