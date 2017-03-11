" Asynchronous Linter Engine

" has('nvim') || v:version >= 800

if !get(g:, 'enable_ale', 0)
  finish
endif

let g:ale_lint_on_save = 1
" Check files on TextChanged event
let g:ale_lint_on_text_changed = 0
" Apply linters on BufEnter and BufRead
let g:ale_lint_on_enter = 1

let g:ale_lint_delay = 420

"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1

" Show loclist or quickfix when a file contains warnigns or errors
"let g:ale_open_list = 1
"let g:ale_keep_list_window_open = 1

if has('multi_byte') && &encoding ==# 'utf-8'
  let s:sign_error = nr2char(0xD7)
  let s:status_error = nr2char(0x2A09)
else
  let s:sign_error = 'x'
  let s:status_error = 'x'
endif

let g:ale_sign_error = s:sign_error
let g:ale_sign_warning = '!'

" let g:ale_warn_about_trailing_whitespace = 1

let g:ale_statusline_format = [s:status_error . ' %d', '! %d', '']

" Change the format for echo messages
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_warning_str = 'W'
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Disable default colors
"highlight clear ALEErrorSign
"highlight clear ALEWarningSign

" command! -n=0 -bar ALEEnable :echo "Loading ALE..."

Plug 'w0rp/ale', {'as': 'async-lint-engine'}

function! s:has_errors(...) abort
  return len(getqflist()) || len(getloclist(0))
endfunction

function! ALEOpenList(...) abort
  let l:winnr = a:0 ? a:1 : 0
  let l:height = 5
  let l:list = []
  if g:ale_set_quickfix
    let l:cmd = 'copen'
    let l:list = getqflist()
  elseif g:ale_set_loclist
    let l:cmd = 'lopen'
    let l:list = getloclist(l:winnr)
  endif
  if len(l:list) > 0
    execute l:cmd . ' ' . l:height
    " If focus changed, jump to the last window
    if l:winnr !=# winnr()
      wincmd p
    endif
  elseif g:ale_set_quickfix
    cclose
  elseif g:ale_set_loclist
    lclose
  endif
endfunction

function! ALECloseList() abort
  if &filetype ==# 'qf'
    return
  endif
  if g:ale_set_quickfix
    cclose
  elseif g:ale_set_loclist
    lclose
  endif
endfunction

augroup ALE
  autocmd!
  " autocmd VimEnter,BufEnter,BufReadPost * call ale#Lint()
  autocmd User ALELint call ALEOpenList()
  " Automatically close corresponding loclist when quitting a window
  autocmd BufHidden,QuitPre * call ALECloseList()
augroup END
