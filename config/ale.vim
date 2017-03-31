" Asynchronous Linter Engine

" https://github.com/showcases/clean-code-linters

if !has('nvim') && v:version < 800
  finish
endif

Plug 'w0rp/ale', {'as': 'async-lint-engine'}

" JavaScript: disable 'eslint' and 'standard' JavaScript linters
let g:ale_linters = {'javascript': ['flow', 'jscs', 'jshint', 'xo']}
" Shell: bashate, shellcheck
" Golang: go get -u github.com/golang/lint/golint
" VimL: pip3 install vim-vint
" Plug 'syngan/vim-vimlint' | Plug 'ynkdir/vim-vimlparser'
" if executable('go')
"   Plug 'haya14busa/go-vimlparser'
" endif

" Apply linters on BufEnter and BufRead
let g:ale_lint_on_enter = 0
" Run the linters whenever a file is saved
let g:ale_lint_on_save = 1
" Check files on TextChanged event (always, insert, normal or never)
let g:ale_lint_on_text_changed = 'never'

let g:ale_lint_delay = 300

" Use quickfix list instead of loclist
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1

" Show loclist or quickfix when a file contains warnigns or errors
let g:ale_open_list = 0
"let g:ale_keep_list_window_open = 1

let g:ale_warn_about_trailing_whitespace = 1

let g:ale_sign_error = 'x' " >>
let g:ale_sign_warning = '!' " --
let g:ale_statusline_format = ['x %d', '! %d', ''] " ['%d error(s)', '%d warning(s)', 'OK']
if has('multi_byte') && &encoding ==# 'utf-8'
  let g:ale_sign_error =  nr2char(0xD7)
  let g:ale_sign_warning = '!'
  let g:ale_statusline_format = [nr2char(0x2A09) . ' %d', '! %d', '']
endif

" Change the format for echo messages
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_warning_str = 'W'
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Disable default colors
"highlight clear ALEErrorSign
"highlight clear ALEWarningSign

" Cycle through errors
"noremap <silent> <C-j> <Plug>(ale_previous_wrap)
"noremap <silent> <C-k> <Plug>(ale_next_wrap)

" Loop through errors with :Ln and :Lp
command! -n=0 -bar Ln :ALENextWrap
command! -n=0 -bar Lp :ALEPreviousWrap

let g:ale_loclist_height = get(g:, 'ale_loclist_height', 5)

function! ALEOpenList(...) abort
  if !exists('g:loaded_ale')
    finish
  endif
  let l:winnr = a:0 ? a:1 : 0
  let l:list = []
  if g:ale_set_quickfix
    let l:cmd = 'copen'
    let l:list = getqflist()
  elseif g:ale_set_loclist
    let l:cmd = 'lopen'
    let l:list = getloclist(l:winnr)
  endif
  if len(l:list) > 0
    execute l:cmd . ' ' . g:ale_loclist_height
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
  if !exists('g:loaded_ale')
    finish
  endif
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
  " autocmd VimEnter,BufReadPost * call ale#Lint()
  autocmd BufEnter,BufRead * if exists('g:loaded_ale') && !&modified | call ale#Lint() | endif
  " Open quickfix or loclist when one or the other is not empty
  autocmd User ALELint call ALEOpenList()
  " Automatically close corresponding loclist when quitting a window
  autocmd BufHidden,QuitPre * call ALECloseList()

  " autocmd QuickFixCmdPost [^l]* cwindow
  " autocmd QuickFixCmdPost    l* lwindow

  " autocmd QuickFixCmdPost * botright cwindow 5
augroup END
