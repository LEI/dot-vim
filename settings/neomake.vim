" Neomake

if !exists('g:loaded_neomake')
  finish
endif

" let g:neomake_serialize = 1
" let g:neomake_serialize_abort_on_error = 1

" Open the location-list or quickfix list when adding entries,
" a value of 2 will preserve the cursor position
let g:neomake_open_list = 2

" Height of the list openened by Neomake, defaults to 10
let g:neomake_list_height = 5

" let g:neomake_echo_current_error = 1

" let g:neomake_error_sign = {'text': '✖', 'texthl': 'NeomakeErrorSign'}
" let g:neomake_warning_sign = {
"   \   'text': '⚠',
"   \   'texthl': 'NeomakeWarningSign',
"   \ }
" let g:neomake_message_sign = {
"   \   'text': '➤',
"   \   'texthl': 'NeomakeMessageSign',
"   \ }
" let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}

augroup NeomakeConfig
  autocmd!
  autocmd BufWritePost,BufReadPost * Neomake
  " autocmd NeomakeFinished * ...
  " autocmd BufWinEnter quickfix nnoremap <silent> <buffer>
  "   \ q :cclose<cr>:lclose<cr>
  " autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix' ) |
  "   \ bd |
  "   \ q | endif
augroup  END
