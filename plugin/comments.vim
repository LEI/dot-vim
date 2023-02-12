" Comments string

" Prefer ftplugin files for setting more options
augroup Comments
  autocmd!
  autocmd FileType cfg,dosini,gitconfig setlocal commentstring=#\ %s
  autocmd FileType xdefaults setlocal commentstring=!\ %s
augroup END
