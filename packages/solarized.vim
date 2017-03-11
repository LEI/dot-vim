" Colorscheme

Plug 'LEI/flattened' " altercation/vim-colors-solarized

function! s:colorscheme()
  try
    set background=dark
    colorscheme flattened_dark
    if exists('*strftime')
      let s:hour = strftime('%H')
      if s:hour > 7 && s:hour < 20
        set background=light
        colorscheme flattened_light
      endif
    endif
    " colorscheme solarized
    " call togglebg#map('<F5>')
  catch /E185:/
    " colorscheme default
  endtry
endfunction

augroup Colors
  autocmd!
  autocmd VimEnter * call s:colorscheme()
augroup END
