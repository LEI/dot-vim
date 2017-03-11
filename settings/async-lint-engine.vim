" ALE

if !has('nvim') && v:version < 800
  finish
endif

let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '']

"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1

" Show loclist or quickfix when a file contains warnigns or errors
let g:ale_open_list = 1
"let g:ale_keep_list_window_open = 1

" Change the format for echo messages
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_warning_str = 'W'
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0

"let g:ale_lint_delay = 200

" Disable default colors
"highlight clear ALEErrorSign
"highlight clear ALEWarningSign

" command! -n=0 -bar ALEEnable :echo "Loading ALE..."

Plug 'w0rp/ale', {'as': 'async-lint-engine'}

augroup ALE
  autocmd!
  autocmd VimEnter,BufReadPost * call ale#Lint()
  " Automatically close corresponding loclist when quitting a window
  autocmd BufHidden,QuitPre * if &filetype != 'qf' | silent! lclose | endif
augroup END
