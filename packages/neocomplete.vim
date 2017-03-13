" NeoComplete

" has('lua')

" if exists('g:loaded_neocomplete')
"   finish
" endif

Plug 'Shougo/neocomplete.vim' | Plug 'Shougo/vimproc.vim', {'do' : 'make'}
let g:neocomplete#enable_at_startup = 1

" Should be set before
" let g:neocomplete#enable_at_startup = 1

" Automatically select the first match
" let g:neocomplete#enable_auto_select = 1

" Enable case sensitivity when an uppercase letter is used
" let g:neocomplete#enable_smart_case = 1
"
" Number of matches to display
let g:neocomplete#max_list = 42

" let g:popup_menu_close = 'neocomplete#complete_common_string'
let g:popup_menu_accept = ''
let g:popup_menu_cancel = 'neocomplete#smart_close_popup'

" Undo completion
" inoremap <expr> <C-e> (pumvisible() ? neocomplete#undo_completion() : "\<C-e>")

" Complete common string
" inoremap <expr> <C-l> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? neocomplete#complete_common_string() : "\<C-l>"
