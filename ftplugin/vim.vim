" Vim

" Stop here if the buffer is a command-line window
if exists('*getcmdwintype') && strlen(getcmdwintype()) > 0
  finish
endif

" setlocal foldenable
" setlocal foldmethod=marker
