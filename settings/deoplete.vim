" Deoplete

if !has('nvim') && has('python3')
  finish
endif

if !get(g:, 'enable_deoplete', 0) " !get(g:, 'loaded_deoplete', 0)
  finish
endif

Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
let g:deoplete#enable_at_startup = 1

" Should be set before
" let g:deoplete#enable_at_startup = 1

" This option enables deoplete only when the popup menu is manually opened
" let g:deoplete#disable_auto_complete = 1

" Enable case sensitivity when an uppercase letter is used
" let g:deoplete#enable_smart_case = 1

" Number of matches to display
let g:deoplete#max_list = 42

let g:popup_menu_accept = 'deoplete#close_popup'
let g:popup_menu_cancel = 'deoplete#smart_close_popup'

" Auto select first match
" set completeopt+=noinsert

" Undo completion
" inoremap <expr> <C-e> pumvisible() ? deoplete#undo_completion() : "\<C-e>"

" Refresh matches (conflicts: surround)
" imap <expr> <C-g> pumvisible() ? deoplete#refresh() : "\<C-g>"

" if get(g:, 'deoplete#disable_auto_complete', 0) > 0
"   imap <expr> <Tab> CheckBackSpace() ? "\<Tab>" : "\<C-n>"
"   imap <expr> <C-n> pumvisible() ? "\<C-n>" : deoplete#mappings#manual_complete()
" endif
