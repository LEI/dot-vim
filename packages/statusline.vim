" Status line

" if exists('g:loaded_statusline')
"   finish
" endif

" Hide mode in command line
set noshowmode

" Default Statusline:
" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

set statusline=%!statusline#Build()
