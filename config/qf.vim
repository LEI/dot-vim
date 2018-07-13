" Quickfix window commands, settings and mappings

Pack 'romainl/vim-qf' ", {'for': 'qf'}

" Information displayed in the 'statusline'
" let g:qf_statusline = {}
" let g:qf_statusline.before = '%<\ '
" let g:qf_statusline.after = '\ %f%=%l\/%-6L\ \ \ \ \ '

" Open the location/quickfix window automatically if there are any errors
let g:qf_auto_open_quickfix = 1
let g:qf_auto_open_loclist = 1

" Automatically adjust the height
let g:qf_auto_resize = 1

" Define the maximum height of the location/quickfix window
let g:qf_max_height = 5

" Automatically quit Vim if the quickfix window is the last one
let g:qf_auto_quit = 1
