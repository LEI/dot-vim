" NeoComplete

" This option should be set earlier
" let g:neocomplete#enable_at_startup = 1

" Automatically select the first match
" let g:neocomplete#enable_auto_select = 1

" Enable case sensitivity when an uppercase letter is used
" let g:neocomplete#enable_smart_case = 1
"
" Number of matches to display
let g:neocomplete#max_list = 42

if !exists('g:loaded_neocomplete')
  finish
endif

" let g:popup_menu_close = 'neocomplete#complete_common_string'
let g:popup_menu_close = '' " Defaults to C-y

" Cancel the completion = <C-e> (use C-h to delete one char)
if get(g:, 'vim_completion_backspace_cancel', 0) > 0
  inoremap <expr> <BS> pumvisible() ? neocomplete#smart_close_popup() : "\<BS>"
endif

" Undo completion
" inoremap <expr> <C-e> (pumvisible() ? neocomplete#undo_completion() : "\<C-e>")

" Complete common string
" inoremap <expr> <C-y> neocomplete#complete_common_string()
inoremap <expr> <C-l> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? neocomplete#complete_common_string() : "\<C-l>"
" imap <expr> <C-l> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? neocomplete#complete_common_string() : "\<C-l>")

" Complete <C-y>
" inoremap <CR> <C-r>=<SID>neocomplete_close_popup()<CR>
