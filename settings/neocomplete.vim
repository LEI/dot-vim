" NeoComplete

" let g:neocomplete#enable_at_startup = 1
" let g:neocomplete#enable_auto_select = 1
" let g:neocomplete#enable_smart_case = 1
" let g:neocomplete#max_list = 1
" let g:neocomplete#auto_completion_start_length = 2 " Keyword source only

if !exists('g:loaded_neocomplete')
  finish
endif

" Use Ctrl-h and Backspace to cancel the completion and delete backword char
" inoremap <expr><C-h> neocomplete#smart_close_popup() . "\<C-h>"
inoremap <expr><BS> (pumvisible() ? neocomplete#smart_close_popup() . "\<C-e>" : "") . "\<BS>"

" Undo completion
" inoremap <expr><C-e> (pumvisible() ? neocomplete#undo_completion() : "\<C-e>")

" Select match
" inoremap <expr><C-y> neocomplete#complete_common_string()
" inoremap <expr><C-l> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? neocomplete#complete_common_string() : "\<C-l>"
" imap <expr><C-l> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? neocomplete#complete_common_string() : "\<C-l>")

" Complete <C-y>
" inoremap <CR> <C-r>=<SID>neocomplete_close_popup()<CR>

function! ClosePopupMenu()
  return neocomplete#complete_common_string()
endfunction
