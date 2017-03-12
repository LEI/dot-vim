" Commentary

Plug 'tpope/vim-commentary'

function! s:loaded()
  augroup VimCommentary
    autocmd!
    " INI
    autocmd FileType inidos setlocal commentstring=#\ %s
    " Xresources
    autocmd FileType xdefaults setlocal commentstring=!\ %s
  augroup END
endfunction

call package#Add({'name': 'commentary', 'on': {'plug_end': function('s:loaded')}})
