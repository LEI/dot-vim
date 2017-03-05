" Deoplete

" This option should be set earlier
" let g:deoplete#enable_at_startup = 1

" This option enables deoplete only when the popup menu is manually opened
" let g:deoplete#disable_auto_complete = 1

" Enable case sensitivity when an uppercase letter is used
" let g:deoplete#enable_smart_case = 1

" Number of matches to display
let g:deoplete#max_list = 42

if !exists('g:loaded_deoplete')
  finish
endif

let g:popup_menu_close = 'deoplete#close_popup'

" Auto select first match
" set completeopt+=noinsert

" Conflicts: SuperTab, endwise?
" Cancel the completion = <C-e> (use C-h to delete one char)
if get(g:, 'vim_completion_backspace_cancel', 0) > 0
  inoremap <expr> <BS> pumvisible() ? deoplete#smart_close_popup() : "\<BS>"
endif

" Undo completion
" inoremap <expr> <C-e> deoplete#undo_completion()

" Refresh candidates list (conflicts: surround)
" imap <expr> <C-g> pumvisible() ? deoplete#refresh() : "\<C-g>"

" Select match or expand snippet
" imap <expr> <C-l> pumvisible() ? deoplete#close_popup() : "\<C-l>"

" Insert candidate and close popup menu
" inoremap <expr> <CR> <C-r>=<SID>deoplete_close_popup()<CR>
" function! s:deoplete_close_popup() abort
"   return pumvisible() ? deoplete#close_popup() . "\<CR>" : "\<CR>"
" endfunction

if get(g:, 'deoplete#disable_auto_complete', 0) > 0
  " Enable autocomplete on Tab
  " inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : CheckBackSpace() ? "\<Tab>" : deoplete#mappings#manual_complete()
  imap <expr> <Tab> CheckBackSpace() ? "\<Tab>" : "\<C-n>"
  imap <expr> <C-n> pumvisible() ? "\<C-n>" : deoplete#mappings#manual_complete()
endif
