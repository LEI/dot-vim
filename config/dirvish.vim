" Dirvish

Plug 'justinmk/vim-dirvish' " Path navigator

" let g:dirvish_mode = 1 " ':sort r /[^\/]$/'
" 1: 'suffixes' and 'wildignore' determine sorting and visibility.
" 2: Shows all files, in the order returned by |glob()|.
" ':{excmd}': Ex command |:execute|d after listing files.

" Paths relative to the current directory
if !has('conceal') " v:version <= 730
  let g:dirvish_relative_paths = 1
endif
