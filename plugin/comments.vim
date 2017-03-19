" Comments string

augroup Comments
  autocmd FileType cfg,inidos setlocal commentstring=#\ %s
  autocmd FileType xdefaults setlocal commentstring=!\ %s
augroup END
