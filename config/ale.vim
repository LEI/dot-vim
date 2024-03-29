" Asynchronous Linter Engine

" https://github.com/showcases/clean-code-linters

if !has('nvim') && v:version < 800
  finish
endif

" https://github.com/dense-analysis/ale#5iii-how-can-i-use-ale-and-cocnvim-together
" if get(g:, 'enable_coc') -- TODO: check displayByAle
"   let g:ale_disable_lsp = 1
" endif

Pack 'w0rp/ale'

let g:ale_linters = get(g:, 'ale_linters', {})

" HTML:
" npm i -g write-good
let g:ale_linters.html = [] " ['tidy', 'write-good']

" See coc.vim and coc-settings.json
if !get(g:, 'enable_coc')
  " JavaScript: disable 'standard', 'jshint'
  let g:ale_linters.javascript = ['eslint', 'flow', 'jscs', 'xo']
  " TypeScript: disable 'standard', 'tslint', 'tsserver', 'typecheck', 'xo'
  let g:ale_linters.typescript = ['eslint']
else
  let g:ale_linters.javascript = []
  let g:ale_linters.typescript = []
endif

" PHP: nunomaduro/larastan
"let g:ale_linters.php = ['langserver', 'phan', 'php', 'phpcs', 'phpmd']
" let g:ale_php_phpstan_executable = 'phpstan'
" let g:ale_php_phpstan_level = 4
" let g:ale_php_phpstan_configuration = 'phpstan.neon'

" Golang:
" $ go get golang.org/x/tools/cmd/goimports
" $ go get -u github.com/golang/lint/golint
" $ go get -u github.com/alecthomas/gometalinter
let g:ale_linters.go = ['gometalinter', 'gofmt']
" Available Linters: ['go build', 'gofmt', 'golint', 'gometalinter', 'gosimple', 'gotype', 'go vet', 'staticcheck']
" Enabled Linters: ['gofmt', 'golint', 'go vet']
" if executable('go')
"   Pack 'haya14busa/go-vimlparser'
" endif
" let g:ale_go_gobuild_options = ''
" let g:ale_go_gofmt_options = ''
let g:ale_go_gometalinter_options = '--fast' " --enable-all
" let g:ale_go_gometalinter_lint_package = 1

" SQL:
" let g:ale_linters.sql = ['sqlint'] " pgsql only
"let g:ale_sql_sqlfmt_options = '-u'

" Shell: bashate, shellcheck
" Use 2 spaces instead of tabs and indent switch cases
" https://google.github.io/styleguide/shell.xml
let g:ale_sh_shfmt_options = '-i 2 -ci'

" VimL: vint
" Pack 'syngan/vim-vimlint' | Pack 'ynkdir/vim-vimlparser'

let g:ale_fixers = get(g:, 'ale_fixers', {})

" Define fixers per filetype (json, less, md -> prettier)
" TODO: remove_trailing_lines, trim_whitespace
let g:ale_fixers.css = ['prettier']
let g:ale_fixers.javascript = ['eslint'] " , 'prettier']
let g:ale_fixers.typescript = ['eslint'] " , 'prettier']
let g:ale_fixers.php = ['phpcbf']
let g:ale_fixers.go = ['goimports']
let g:ale_fixers.sh = ['shfmt']
"let g:ale_fixers.sql = ['sqlfmt']

" Fix files automatically on save
let g:ale_fix_on_save = 1

" Do not lint or fix minified files.
let g:ale_pattern_options = {
      \   '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
      \   '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
      \ }

" Required if g:ale_pattern_options is configured outside of vimrc
let g:ale_pattern_options_enabled = 1

" Bind F8 to fixing problems with ALE
"nmap <F8> <Plug>(ale_fix)

" Use quickfix list instead of loclist
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1

" Show loclist or quickfix when a file contains warnigns or errors
let g:ale_open_list = 0
"let g:ale_keep_list_window_open = 1
let g:ale_list_window_size = 5

" Apply linters on BufEnter and BufRead
let g:ale_lint_on_enter = 1
" Run the linters whenever a file is saved
let g:ale_lint_on_save = 1
" Check files on TextChanged event (always, insert, normal or never)
let g:ale_lint_on_text_changed = 'never'
" Milliseconds delay after the text is changed
let g:ale_lint_delay = 300

let g:ale_warn_about_trailing_whitespace = 1

" Change the format for echo messages
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_warning_str = 'W'
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_echo_msg_format = '[%linter%% code%] %s'

let g:ale_sign_error = 'x' " >>
let g:ale_sign_warning = '!' " --
if has('multi_byte') && &encoding ==# 'utf-8'
  let g:ale_sign_error = nr2char(0x2A09) " nr2char(0xD7)
  let g:ale_sign_warning = '!'
endif

" Disable virtual text (default: 'all')
let g:ale_virtualtext_cursor = 0

function! ALEStatus() abort
  let l:str = ''
  let l:buf = bufnr('')
  let l:prefix = '['
  let l:suffix = ']'
  let l:counts = ale#statusline#Count(l:buf)

  if l:counts.total == 0
    return l:str
  endif

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  if l:all_errors > 0
    let l:first = ale#statusline#FirstProblem(l:buf, 'error')
    " let l:lnum = type(l:first) == v:t_dict && get(l:first, 'lnum') ? l:first.lnum : -1
    " \ . (l:lnum >= 0 ? l:prefix . l:lnum. l:suffix : ' ')
    let l:str.= l:all_errors . ' ' . g:ale_sign_error
  endif

  if l:all_errors > 0 && l:all_non_errors > 0
    let l:str.= ' '
  endif

  if l:all_non_errors > 0
    let l:first = ale#statusline#FirstProblem(l:buf, 'warning')
    " let l:lnum = type(l:first) == v:t_dict && get(l:first, 'lnum') ? l:first.lnum : -1
    " \ . (l:lnum >= 0 ? l:prefix . l:lnum. l:suffix : ' ')
    let l:str.= l:all_non_errors . ' ' . g:ale_sign_warning
  endif

  return l:str
endfunction

" Disable default colors
"highlight clear ALEErrorSign
"highlight clear ALEWarningSign

" Cycle through errors
"noremap <silent> <C-j> <Plug>(ale_previous_wrap)
"noremap <silent> <C-k> <Plug>(ale_next_wrap)

" Loop through errors with :Ln and :Lp
command! -n=0 -bar Ln :ALENextWrap
command! -n=0 -bar Lp :ALEPreviousWrap

" function! s:IsCmdWin()
"   return exists('*getcmdwintype') && !empty(getcmdwintype())
" endfunction

" function! s:close()
"   if s:IsCmdWin()
"     return
"   endif
"   if g:ale_set_quickfix " && qf#IsQfWindowOpen()
"     cclose " call qf#toggle#ToggleQfWindow(1)
"   elseif g:ale_set_loclist " && qf#IsLocWindowOpen(l:winnr)
"     lclose " call qf#toggle#ToggleLocWindow(1)
"   endif
" endfunction

" function! OpenList(...)
"   let l:winnr = a:0 ? a:1 : winnr()
"   if g:ale_set_quickfix && len(getqflist()) > 0
"     if exists('*qf#OpenQuickfix') " !qf#IsQfWindowOpen()
"       call qf#OpenQuickfix()
"     else
"       copen 5
"     endif
"   elseif g:ale_set_loclist && len(getloclist(l:winnr)) > 0
"     if exists('*qf#OpenLoclist') " !qf#IsLocWindowOpen(l:winnr)
"       call qf#OpenLoclist()
"     else
"       lopen 5
"     endif
"   else
"     call s:close()
"   endif
"   " If focus changed, jump to the last window
"   if l:winnr !=# winnr()
"     wincmd p
"   endif
" endfunction

" function! CloseList(...)
"   " let l:winnr = a:0 ? a:1 :winnr()
"   if &filetype ==# 'qf' " || winnr('$') == 2
"     return
"   endif
"   call s:close()
" endfunction

" augroup ALE
"   autocmd!
"   " Run the linters on enter
"   "autocmd BufEnter,BufReadPost * call ale#Lint()
"   " Open the quickfix or location list after linting
"   autocmd User ALELint call OpenList()
"   " Automatically close the corresponding list when hiding a buffer
"   autocmd BufHidden * call CloseList()

"   " autocmd QuickFixCmdPost [^l]* cwindow
"   " autocmd QuickFixCmdPost    l* lwindow
"   " autocmd QuickFixCmdPost * botright cwindow 5
" augroup END
