" NeoComplete

" let g:neocomplete#enable_at_startup = 1
" let g:neocomplete#enable_auto_select = 1
" let g:neocomplete#enable_smart_case = 1
" let g:neocomplete#max_list = 100

if !exists('g:loaded_neocomplete')
  finish
endif

" Use Ctrl-h and Backspace to cancel the completion and delete backword char
inoremap <expr><C-h> neocomplete#smart_close_popup() . "\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup() . "\<C-h>"

" Undo completion
inoremap <expr><C-g> neocomplete#undo_completion()

" Select remaining match
inoremap <expr><C-l> neocomplete#complete_common_string()

" Next and previous completion Tab and Shift-Tab
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" Fix Shift-Tab? :exe 'set t_kB=' . nr2char(27) . '[Z'
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"
