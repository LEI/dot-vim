" Asynchronous Linter Engine

" has('nvim') || v:version >= 800

" if exists('g:loaded_ale')
"   finish
" endif

Plug 'w0rp/ale', {'as': 'async-lint-engine'}

let g:ale_lint_on_save = 1
" Check files on TextChanged event
let g:ale_lint_on_text_changed = 0
" Apply linters on BufEnter and BufRead
let g:ale_lint_on_enter = 1

let g:ale_lint_delay = 300

"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1

" Show loclist or quickfix when a file contains warnigns or errors
"let g:ale_open_list = 1
"let g:ale_keep_list_window_open = 1

let g:ale_warn_about_trailing_whitespace = 1

let g:ale_sign_error = 'x'
let g:ale_sign_warning = '!'
let s:status_error = 'x'

if has('multi_byte') && &encoding ==# 'utf-8'
  let g:ale_sign_error =  nr2char(0xD7)
  let g:ale_sign_warning = '!'
  let s:status_error = nr2char(0x2A09)
endif

let g:ale_statusline_format = [s:status_error . ' %d', '! %d', '']

" Change the format for echo messages
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_warning_str = 'W'
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Disable default colors
"highlight clear ALEErrorSign
"highlight clear ALEWarningSign

" Map movement through errors with wrapping
"noremap <silent> <C-j> <Plug>(ale_previous_wrap)
"noremap <silent> <C-k> <Plug>(ale_next_wrap)

" Loop through errors with :Ln and :Lp
command! -n=0 -bar Ln :ALENextWrap
command! -n=0 -bar Lp :ALEPreviousWrap

function! ALEOpenList(...) abort
  let l:winnr = a:0 ? a:1 : 0
  let l:height = get(g:, 'ale_loclist_height', 5)
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
  " autocmd VimEnter,BufEnter * call ale#Lint()
  autocmd User ALELint call ALEOpenList()
  " Automatically close corresponding loclist when quitting a window
  autocmd BufHidden,QuitPre * call ALECloseList()
augroup END
