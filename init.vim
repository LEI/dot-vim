" Vim

runtime before.vim
runtime plug.vim

" Load global options
source ~/.vim/config.vim

if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif
