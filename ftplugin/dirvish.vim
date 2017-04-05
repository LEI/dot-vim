" Dirvish

" Sort folders at the top
" sort r /[^\/]$/

" Map t to open in new tab
nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>

" Map gr to reload the Dirvish buffer
nnoremap <silent><buffer> gr :<C-U>Dirvish %<CR>

" Map gh to hide dot-prefixed files
nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>

" Enable :Gstatus
if exists('g:loaded_fugitive')
  call fugitive#detect(@%)
endif

" Trigger hidden buffer manually (noautocmd is used)
if bufnr('$') > 1 && exists('#BufHidden#*')
  doautocmd BufHidden *
endif
