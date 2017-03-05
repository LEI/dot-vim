" Deoplete

" let g:deoplete#disable_auto_complete = 1
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#enable_smart_case = 1
" let g:deoplete#max_list = 100

if !exists('g:loaded_deoplete')
  finish
endif

" Auto select first match
" set completeopt+=noinsert

" Conflicts: SuperTab, endwise?
" Use Backspace or Ctrl-h to stop completion go back to original text
inoremap <expr><BS> (pumvisible() ? deoplete#smart_close_popup() . "\<C-e>" : "") . "\<BS>"
" imap <expr><BS> pumvisible() ? deoplete#smart_close_popup() : "\<BS>"
" inoremap <expr><C-h> (pumvisible() ? deoplete#close_popup() . "\<C-e>" : "") . "\<C-h>"

" inoremap <expr><C-h> deoplete#smart_close_popup() . "\<C-h>"
" inoremap <expr><C-h> pumvisible() ? ("\<Plug>deoplete#smart_close_popup()" : "") . "\<C-h>"
" inoremap <expr><BS> pumvisible() ? deoplete#close_popup() : "\<BS>"

" Undo completion
" inoremap <expr><C-e> deoplete#undo_completion()

" Refresh candidates list (conflicts: surround)
" imap <expr><C-g> pumvisible() ? deoplete#refresh() : "\<C-g>"

" Select match or expand snippet
" imap <expr><C-l> pumvisible() ? deoplete#close_popup() : "\<C-l>"

" Insert candidate and close popup menu
" inoremap <expr><CR> <C-r>=<SID>deoplete_close_popup()<CR>
" function! s:deoplete_close_popup() abort
"   return pumvisible() ? deoplete#close_popup() . "\<CR>" : "\<CR>"
" endfunction

if get(g:, 'deoplete#disable_auto_complete', 0) > 0
  " Enable autocomplete on Tab
  " inoremap <expr><Tab> pumvisible() ? "\<C-n>" : CheckBackSpace() ? "\<Tab>" : deoplete#mappings#manual_complete()
  imap <expr><Tab> CheckBackSpace() ? "\<Tab>" : "\<C-n>"
  imap <expr><C-n> pumvisible() ? "\<C-n>" : deoplete#mappings#manual_complete()
endif

function! ClosePopupMenu()
  return "\<C-n>" . deoplete#close_popup()
endfunction
