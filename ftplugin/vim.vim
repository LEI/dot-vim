" Vim

" Stop here if the buffer is a command-line window
if exists('*getcmdwintype') && strlen(getcmdwintype()) > 0
  finish
endif

" setlocal foldenable
" setlocal foldmethod=marker

" Amount of indent for a continuation line
" FIXME after FileType * (vim-sleuth)
" let g:vim_indent_cont = &shiftwidth * 3
