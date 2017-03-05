" Deoplete

" let g:deoplete#disable_auto_complete = 1
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#enable_smart_case = 1
" let g:deoplete#max_list = 100

if !exists('g:loaded_deoplete')
  finish
endif

" Use C-h or Backspace to delete backword char (conflicts: SuperTab, endwise?)
inoremap <expr><C-h> deoplete#smart_close_popup() . "\<C-h>"
inoremap <expr><BS> deoplete#smart_close_popup() . "\<C-h>"

" Undo completion (conflicts: surround?)
inoremap <expr><C-g> deoplete#undo_completion()

" Refresh candidates list
inoremap <expr><C-l> pumvisible() ? deoplete#refresh() : "\<C-l>"

" Insert candidate and close popup menu
" inoremap <expr><CR> <C-r>=<SID>deoplete_close_popup()<CR>
" function! s:deoplete_close_popup() abort
"   return pumvisible() ? deoplete#close_popup() . "\<CR>" : "\<CR>"
" endfunction

if get(g:, 'deoplete#disable_auto_complete', 0) > 0
  " Enable autocomplete on Tab
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : CheckBackSpace() ? "\<Tab>" : deoplete#mappings#manual_complete()
endif
