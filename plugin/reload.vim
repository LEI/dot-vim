" Auto reloading

augroup Reload
  " Auto reload vimrc on save
  autocmd BufWritePost $MYVIMRC nested source %
  " TODO: Xdefaults
augroup END
