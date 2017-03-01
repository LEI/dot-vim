" Fugitive

if !exists('g:loaded_fugitive')
  finish
endif

" Auto-clean git objects buffers
autocmd BufReadPost fugitive://* set bufhidden=delete
