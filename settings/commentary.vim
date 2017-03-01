" Commentary

if !exists('g:loaded_commentary')
  finish
endif

" INI
" autocmd FileType inidos setlocal commentstring=#\ %s

" Xresources
autocmd FileType xdefaults setlocal commentstring=!\ %s
