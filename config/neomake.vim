" Neomake

if !has('nvim') || v:version < 704 || v:version == 704 && !has('patch503')
  finish
endif

Pack 'neomake/neomake'

" let g:neomake_vim_enabled_makers = ['vimlint']
" let g:neomake_vim_vimlint_exe = g:plug_home . '/vim-vimlint/bin/vimlint.sh'
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

  " Run checkers on open and save in quickfix list
function! Neomake()
  let l:cmd = 'Neomake' " 0verb Neomake!
  if &filetype ==# 'go'
    " Use location list for `go vet`
    let l:cmd.= '!'
  endif
  execute l:cmd
endfunction

augroup NeomakeConfig
  autocmd!
  " autocmd User NeomakeFinished
  " autocmd User NeomakeCountsChanged redrawstatus
  autocmd BufReadPost,BufWritePost * call Neomake()

  " Remap 'q' to close quickfix or location list
  autocmd BufWinEnter quickfix nnoremap <silent> <buffer> q :cclose<CR>:lclose<CR>
  "autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix' ) | bd | q | endif

  " Automatically close corresponding loclist when quitting a window
  autocmd BufHidden,QuitPre * if &filetype != 'qf' | silent! lclose | endif
  " autocmd BufUnload * if &filetype != 'qf' | silent! lclose | endif
  " autocmd QuitPre * let g:neomake_verbose = 0

  " Reset sign column color background
  "autocmd ColorScheme * highlight! link SignColumn ColorColumn
augroup END
