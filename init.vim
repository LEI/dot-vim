" Vim

runtime before.vim

" Initialize plugins
runtime plug.vim

" Load global options
runtime config.vim

if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif
