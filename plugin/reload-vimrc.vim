" Auto reload vimrc on save

augroup VimReload
  autocmd!
  autocmd BufWritePost $MYVIMRC nested source %
augroup END
