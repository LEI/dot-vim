" Neomake

" if !exists('g:loaded_neomake')
"   finish
" endif

" let g:neomake_vim_enabled_makers = ['vimlint']
" let g:neomake_vim_vimlint_exe = $PLUGINS . '/vim-vimlint/bin/vimlint.sh'
" let g:neomake_vim_vimlint_args = ['-u']

" Disable airline extension
" let g:airline#extensions#neomake#enabled = 0

let g:neomake_verbose = 1
" let g:neomake_echo_current_error = 1

" let g:neomake_serialize = 1
" let g:neomake_serialize_abort_on_error = 1

" Open the location-list or quickfix list when adding entries,
" a value of 2 will preserve the cursor position
let g:neomake_open_list = 2

" Height of the list openened by Neomake, defaults to 10
let g:neomake_list_height = 5

let g:neomake_error_sign = {'text': '×', 'texthl': 'Error'}
let g:neomake_warning_sign = {'text': '!', 'texthl': 'WarningMsg'}
" let g:neomake_message_sign = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
" let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}

augroup NeomakeConfig
  autocmd!
  " Run checkers on open and on save in location list
  " 0verb Neomake!
  autocmd BufReadPost,BufWritePost * Neomake
  " Auto close loclist
  autocmd BufWinLeave * if empty(&bt) | lclose | endif
  " autocmd User NeomakeFinished
  autocmd User NeomakeCountsChanged redrawstatus
  " " Reset sign column background
  " autocmd VimEnter,ColorScheme * highlight clear SignColumn

  " autocmd NeomakeFinished * ...
  autocmd! QuitPre * let g:neomake_verbose = 0
  " autocmd BufWinEnter quickfix nnoremap <silent> <buffer>
  "   \ q :cclose<cr>:lclose<cr>
  " autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix' ) |
  "   \ bd |
  "   \ q | endif
  " autocmd ColorScheme * highlight! link SignColumn ColorColumn
augroup END
