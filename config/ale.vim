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
let g:ale_lint_on_enter = 1
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

function! s:IsCmdWin()
  return exists('*getcmdwintype') && !empty(getcmdwintype())
endfunction

function! s:close()
  if s:IsCmdWin()
    return
  endif
  if g:ale_set_quickfix " && qf#IsQfWindowOpen()
    cclose " call qf#toggle#ToggleQfWindow(1)
  elseif g:ale_set_loclist " && qf#IsLocWindowOpen(l:winnr)
    lclose " call qf#toggle#ToggleLocWindow(1)
  endif
endfunction

function! OpenList(...)
  let l:winnr = a:0 ? a:1 : winnr()
  if g:ale_set_quickfix && len(getqflist()) > 0
    if exists('*qf#OpenQuickfix') " !qf#IsQfWindowOpen()
      call qf#OpenQuickfix()
    else
      copen 5
    endif
  elseif g:ale_set_loclist && len(getloclist(l:winnr)) > 0
    if exists('*qf#OpenLoclist') " !qf#IsLocWindowOpen(l:winnr)
      call qf#OpenLoclist()
    else
      lopen 5
    endif
  else
    call s:close()
  endif
  " If focus changed, jump to the last window
  if l:winnr !=# winnr()
    wincmd p
  endif
endfunction

function! CloseList(...)
  " let l:winnr = a:0 ? a:1 :winnr()
  if &filetype ==# 'qf' " || winnr('$') == 2
    return
  endif
  call s:close()
endfunction

augroup ALE
  autocmd!
  " Run the linters on enter
  "autocmd BufEnter,BufReadPost * call ale#Lint()
  " Open the quickfix or location list after linting
  autocmd User ALELint call OpenList()
  " Automatically close the corresponding list when hiding a buffer
  autocmd BufHidden * call CloseList()

  " autocmd QuickFixCmdPost [^l]* cwindow
  " autocmd QuickFixCmdPost    l* lwindow
  " autocmd QuickFixCmdPost * botright cwindow 5
augroup END
