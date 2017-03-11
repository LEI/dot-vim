" Unimpaired

Plug 'tpope/vim-unimpaired'

" if !exists('g:loaded_unimpaired')
"   finish
" endif

" Fix AZERTY
for s:c in map(range(65,90) + range(97,122),'nr2char(v:val)')
  exec 'nmap ('.s:c.' ['.s:c
  exec 'xmap ('.s:c.' ['.s:c
  exec 'nmap )'.s:c.' ]'.s:c
  exec 'xmap )'.s:c.' ]'.s:c
endfor

" Bubble single or multiple lines
" noremap <C-Up> [e
" noremap <C-Down> ]e
" vnoremap <C-Up> [egv
" vnoremap <C-Down> ]egv
