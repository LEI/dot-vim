" Neomake

" if !exists('g:loaded_neomake')
"   finish
" endif

" let g:neomake_vim_enabled_makers = ['vimlint']
" let g:neomake_vim_vimlint_exe = $PLUGINS . '/vim-vimlint/bin/vimlint.sh'
" let g:neomake_vim_vimlint_args = ['-u']

" Disable airline extension
" let g:airline#extensions#neomake#enabled = 0

" let g:neomake_verbose = 1
" let g:neomake_echo_current_error = 1

" let g:neomake_serialize = 1
" let g:neomake_serialize_abort_on_error = 1

" Open the location-list or quickfix list when adding entries,
" a value of 2 will preserve the cursor position
let g:neomake_open_list = 2

" Height of the list openened by Neomake, defaults to 10
let g:neomake_list_height = 5

let g:neomake_error_sign = {'text': '×'} ", 'texthl': 'Error'}
let g:neomake_warning_sign = {'text': '!'} ", 'texthl': 'WarningMsg'}
" let g:neomake_message_sign = {'text': '➤', 'texthl': 'NeomakeMessageSign'}
" let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}

function! s:NeomakeCheck()
  let l:cmd = '0verb Neomake'
  if &filetype ==# 'go'
    let l:cmd.= '!'
  endif
  execute l:cmd
endfunction

function! s:NeomakeClose()
  if !empty(&buftype) || winnr('$') < 3
    return
  endif
  " winnr('$') == 2 " bdelete | quit
  if len(getloclist(0)) > 0
    lclose
  elseif len(getqflist()) > 0
    cclose
  endif
endfunction

" Close vim if the last buffer is a quickfix
function! s:CloseLastQf()
  if winnr('$') > 1
    return
  endif
  if &buftype ==# 'quickfix'
    quit
  endif
  " if empty(&buftype)
  "   if len(getloclist(0)) > 0
  "     lopen " TODO fix cursor
  "   elseif len(getqflist()) > 0
  "     copen " TODO fix cursor
  "   endif
  " endif
endfunction

augroup NeomakeConfig
  autocmd!
  " Run checkers on open and on save in quickfix list (location list for golang)
  autocmd BufReadPost,BufWritePost * call s:NeomakeCheck()
  " autocmd User NeomakeFinished
  " autocmd User NeomakeCountsChanged redrawstatus
  autocmd BufWinLeave * call s:NeomakeClose()
  autocmd BufEnter * call s:CloseLastQf()

  " Automatically close corresponding loclist when quitting a window
  " autocmd QuitPre * if &filetype != 'qf' | silent! lclose | endif

  " autocmd BufWinEnter quickfix nnoremap <silent> <buffer>
  "   \ q :cclose<cr>:lclose<cr>
  " autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix' ) |
  "   \ bd |
  "   \ q | endif
  " autocmd ColorScheme * highlight! link SignColumn ColorColumn
  autocmd! QuitPre * let g:neomake_verbose = 0
augroup END
