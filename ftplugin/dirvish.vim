" Dirvish

" Sort folders at the top
" sort r /[^\/]$/

" Trigger hidden buffer manually (noautocmd is used)
if bufnr('$') > 1 && exists('#BufHidden#*')
  doautocmd BufHidden *
endif
