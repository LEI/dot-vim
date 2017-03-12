" Commentary

if exists('g:loaded_commentary')
  finish
endif

Plug 'tpope/vim-commentary'

function! s:loaded()
  augroup VimCommentary
    autocmd!
    autocmd FileType cfg,inidos setlocal commentstring=#\ %s
    autocmd FileType xdefaults setlocal commentstring=!\ %s
  augroup END
endfunction

call package#Add({'name': 'commentary', 'on': {'plug_end': function('s:loaded')}})
