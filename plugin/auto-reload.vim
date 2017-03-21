" Auto reloading

augroup AutoReload
  " Auto reload vimrc on save
  autocmd BufWritePost $MYVIMRC nested source %
  " autocmd BufWritePost ~/.Xdefaults :redraw | :echo system('xrdb ' . expand('<amatch>'))
augroup END
