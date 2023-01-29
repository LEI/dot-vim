if !exists(':terminal')
  finish
endif

" Escape
tmap <Esc> <C-\><C-n>
tmap <C-o> <C-\><C-n>

" Navigation
tmap <C-h> <Cmd>:wincmd h<CR>
tmap <C-j> <Cmd>:wincmd j<CR>
tmap <C-k> <Cmd>:wincmd k<CR>
tmap <C-l> <Cmd>:wincmd l<CR>

" autocmd! TermOpen term://*toggleterm#* lua set_toggle_term_keymaps()
