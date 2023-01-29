" Unimpaired

Pack 'tpope/vim-unimpaired'

if has('nvim')
  finish
endif

" nmap ( [
" nmap ) ]
" omap ( [
" omap ) ]
" xmap ( [
" xmap ) ]

" Remap unimpaired shortcuts to ( and ) for azerty keyboards
for s:c in map(range(65,90) + range(97,122),'nr2char(v:val)')
  exec 'nmap ('.s:c.' ['.s:c
  exec 'xmap ('.s:c.' ['.s:c
  exec 'nmap )'.s:c.' ]'.s:c
  exec 'xmap )'.s:c.' ]'.s:c
endfor

" " Bubble single or multiple lines
" noremap <C-Up> [e
" noremap <C-Down> ]e
" vnoremap <C-Up> [egv
" vnoremap <C-Down> ]egv
