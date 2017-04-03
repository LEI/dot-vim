" Improved defaults

set backspace=indent,eol,start " Allow backspace over everything in insert mode

if !has('nvim')
  set esckeys " Recognize escape immediately
endif

set timeout
set timeoutlen=1000

if !has('nvim')
  set ttimeout " Time out for key codes
  set ttimeoutlen=100 " Wait up to 100ms after Esc for special keys
endif

if has('extra_search')
  set hlsearch " Keep all matches highlighted when there is a previous search
endif

if has('reltime')
  set incsearch " Do incremental searching when it's possible to timeout
endif

" set fileformats=unix,dos,mac " Use Unix as the standard file type

set nrformats-=octal " Disable octal format for number processing using CTRL-A and CTRL-X

" CTRL-U in insert mode deletes a lot: use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break
inoremap <C-U> <C-G>u<C-U>

if has('syntax') && &t_Co > 2 || has('gui_running')
  " let g:c_comment_string = 1 " Highlight strings inside C comments
  if !exists('g:syntax_on')
    syntax enable
  endif
endif

if has('autocmd')
  filetype plugin indent on " Enable file type detection
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a mapping
  " If set (default), this may break plugins but it's backward compatible
  set nolangremap
endif

" Load matchit.vim
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &runtimepath) ==# ''
  runtime! macros/matchit.vim
endif

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif
