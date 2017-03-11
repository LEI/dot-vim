" Colorscheme

Plug 'LEI/flattened'
" Plug 'altercation/vim-colors-solarized'

function! s:colorscheme()
  " colorscheme solarized
  " call togglebg#map('<F5>')
  let l:bg = 'dark'
  if exists('*strftime')
    let s:hour = strftime('%H')
    if s:hour > 7 && s:hour < 20
      let l:bg = 'light'
    endif
  endif
  try
    let &background = l:bg
    execute 'colorscheme flattened_' . l:bg
  catch /E185:/
    " colorscheme default
  endtry
endfunction

augroup Colors
  autocmd!
  autocmd VimEnter * call s:colorscheme()
augroup END
