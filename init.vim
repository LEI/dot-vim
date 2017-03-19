" Vim

" https://github.com/christoomey/dotfiles
" https://github.com/gfontenot/dotfiles/tree/master/tag-vim
" https://github.com/thoughtbot/dotfiles

" zi Folding on/off
" zR Open all
" zM Close all
" za Toggle current
" zj Down to the start of the next
" zk Up to the end of the previous

" runtime before.vim

" Functions {{{1

function! s:home(path)
  return expand(g:home . '/' . a:path)
endfunction

function! IsEnabled(path)
  let l:name = fnamemodify(a:path, ':t:r')
  " Enable Package: let g:enable_{l:name} = 1
  " !exists('g:enable_' . l:name) || g:enable_{l:name} == 0
  let l:enabled = get(g:, 'enable_' . l:name, 0) == 1
  for l:pattern in get(g:, 'plugins_enable', [])
    if matchstr(l:name, l:pattern)
      let l:enabled = 1
      break
    endif
  endfor
  " echom l:name . ' is ' . (l:enabled ? 'enabled' : 'disabled')
  return l:enabled
endfunction

function! SourceEnabledDir(path)
  return init#SourceDirIf(a:path, 'IsEnabled')
endfunction

" Variables {{{1

let g:home = split(&runtimepath, ',')[0] " $HOME . '/.vim'
let g:plug_path = s:home('autoload/plug.vim')
let g:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" let g:plug_home = s:home('plugged')
" let g:plugins_enable = ['plugins']

" General:
let g:enable_plugins = 1
let g:enable_colorscheme = 1

" Improvements:
let g:enable_commentary = 1
let g:enable_fugitive = 1
let g:enable_splitjoin = 1
let g:enable_tabular = 0
let g:enable_unimpaired = 1
let g:enable_textobjuser = 1

" Search:
let g:enable_ctags = 1
let g:enable_ctrlp = 1
let g:ctrlp_status_func = {'main': 'status#ctrlp#Main', 'prog': 'status#ctrlp#Prog'}

" Languages:
let g:enable_polyglot = 1
let g:enable_tern = 1

" Formatting: google/vim-codefmt
" let g:enable_editorconfig = 1 " Breaks &et

" Syntax Checkers: scrooloose/syntastic, maralla/validator.vim
let g:enable_neomake = 0
let g:enable_ale = 1

" Auto Completion: ervandew/supertab, vim-scripts/AutoComplPop
let g:enable_youcompleteme = 0
let g:enable_ultisnips = g:enable_youcompleteme
let g:enable_deoplete = has('nvim')
let g:enable_neocomplete = !has('nvim')
let g:enable_neosnippet = g:enable_deoplete || g:enable_neocomplete

" Plugins {{{1

let s:did_download = 0
if empty(glob(g:plug_path)) " && confirm('Download vim-plug in ' . g:plug_path . '?') == 1
  execute 'silent !curl -fLo ' . g:plug_path . ' --create-dirs ' . g:plug_url
  let s:did_download = 1
endif

" Start Vim Plug
call plug#begin()

" runtime packages.vim

" Register plugins
call SourceEnabledDir(s:home('plugins'))

" Add plugins to &runtimepath
call plug#end()

if get(s:, 'did_download', 0) == 1
  PlugInstall --sync | source $MYVIMRC
endif

" Register plugins
call init#SourceDir(s:home('config'))

" command! -nargs=0 -bar Install PlugInstall --sync | source $MYVIMRC
" command! -nargs=0 -bar Update PlugUpdate --sync | source $MYVIMRC
" command! -nargs=0 -bar Upgrade PlugUpdate! --sync | PlugUpgrade | source $MYVIMRC

" Load matchit.vim
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &runtimepath) ==# ''
  runtime! macros/matchit.vim
endif

" Defaults {{{1

set backspace=indent,eol,start " Allow backspace over everything in insert mode

set nrformats-=octal " Disable octal format for number processing using Ctrl-A and Ctrl-X

set timeout
set timeoutlen=1000
" set ttimeout " Time out for key codes
" set ttimeoutlen=100 " Wait up to 100ms after Esc for special keys

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if has('syntax')
  set synmaxcol=500 " Limit syntax highlighting for long lines
  if !exists('g:syntax_on') " &t_Co > 2 || has('gui_running')
    syntax enable
  endif
endif

if has('autocmd')
  filetype plugin indent on " Enable file type detection
endif

if has('langmap') && exists('+langremap')
  set nolangremap " Prevent that the langmap option applies to characters that result from a mapping
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif

if &tabpagemax < 50
  set tabpagemax=50
endif

if !empty(&viminfo)
  set viminfo^=!
endif

" Options {{{1

set nostartofline " Keep the cursor on the same column if possible

set lazyredraw " Redraw only if necessary, faster macros

" set esckeys " Recognize escape immediately

set exrc " Enable per-directory .vimrc files
set secure " Disable unsafe commands

set modeline " Allow setting some options at the beginning and end of the file
set modelines=2 " Number of lines checked for set commands

" set title " Set the title of the window to 'titlestring'

" set fileformats=unix,dos,mac " Use Unix as the standard file type

set report=0 " Always report changed lines (default threshold: 2)

set autoread " Reload unmodified files when changes are detected outside

" set autowrite " Automatically :write before running commands

set hidden " Allow modified buffers in the background

set shortmess=atI " Avoid hit-enter prompts caused by file messages
"
" set noshowmatch " Do not show matching brackets when text indicator is over them

" set matchtime=2 " How many tenths of a second to blink when matching brackets

" set matchpairs+=<:> " HTML brackets

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j " Delete comment character when joining commented lines
endif

set nojoinspaces " Insert only one space after punctuation

set nowrap " Do not wrap by default

set clipboard=unnamed " Use system clipboard

" Mouse {{{1

" n  Normal mode
" v  Visual mode
" i  Insert mode
" c  Command-line mode
" h  all previous modes when editing a help file
" a  all previous modes
" r  for |hit-enter| and |more-prompt| prompt
if has('mouse')
  set mouse=a
endif

if !has('nvim')
  " Fix mouse inside screen and tmux
  if &term =~# '^screen' || strlen($TMUX) > 0
    set ttymouse=xterm2
  endif
  " Faster terminal redrawing
  set ttyfast
endif

" Bells {{{1

set noerrorbells " Disable audible bell for error messages
set visualbell " Use visual bell instead of beeping
set t_vb= " Disable audible and visual bells

" Sessions and views {{{1

" View Options:
" cursor: cursor position in file and in window
" folds: manually created folds, opened/closed folds and local fold options
" options: options and mappings local to a window or buffer (not global values for local options)
" localoptions: same as 'options'
" slash,unix: useful on Windows when sharing view files

" set viewdir=$HOME/.vim/view " Customize location of saved views
set viewoptions-=options " folds,options,cursor

set sessionoptions-=options

" Keep undo history across sessions
" expand(get(g:, 'undodir', '~/.vim/backups'))
let g:undodir = get(g:, 'undodir', s:home('backups'))
if has('persistent_undo') " && exists('g:undodir')
  " Disable swapfiles and backups
  set noswapfile
  set nobackup
  set nowritebackup
  if exists('*mkdir') && !isdirectory(g:undodir)
    call mkdir(g:undodir)
  endif
  let &undodir = g:undodir
  set undofile
endif

" Characters {{{1

" Default: set fillchars=stl:^,stlnc:=,vert:\|,fold:-,diff:-
" let &fillchars='stl: ,stlnc: '

set list " Show invisible characters
" let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+ " ,eol:$
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:' . nr2char(0x25B8) . ' '
        \ . ',trail:' . nr2char(0x00B7)
        \ . ',extends:' . nr2char(0x276F)
        \ . ',precedes:' . nr2char(0x276E)
        \ . ',nbsp:' . nr2char(0x005F)
        \ . ',eol:' . nr2char(0x00AC)
  " " Show line breaks (arrows: 0x21AA or 0x08627)
  " let &showbreak = nr2char(0x2026) " Ellipsis
endif

" Terminal {{{1

if &term =~# '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen
  " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Allow color schemes to use bright colors without forcing bold
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" Enable true colors if supported (:h xterm-true-color)
" http://sunaku.github.io/tmux-24bit-color.html#usage
let g:term_true_color = $COLORTERM ==# 'truecolor' || $COLORTERM =~# '24bit'
      \ || $TERM_PROGRAM ==# 'iTerm.app' " $TERM ==# 'rxvt-unicode-256color'
" has('nvim') || v:version > 740 || v:version == 740 && has('patch1799')
" NVIM_TUI_ENABLE_TRUE_COLOR?
if (has('nvim') || has('patch-7.4.1778')) && get(g:, 'term_true_color', 0)
  set termguicolors
  " let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
  " let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
  " Correct RGB escape codes for vim inside tmux
  if !has('nvim') && $TERM ==# 'screen-256color'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
endif

" set t_AB=^[[48;5;%dm
" set t_AF=^[[38;5;%dm

" Cursor {{{1

if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
elseif empty($TMUX)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  if v:version >= 800
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  endif
else
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  if v:version >= 800
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
  endif
endif

" Override cursor highlight groups
function! HighlightCursor() abort
  if &background ==# 'dark'
    " highlight Cursor ctermfg=8 ctermbg=4 guifg=#002b36 guibg=#268bd2
    highlight Cursor ctermfg=0 ctermbg=15 guifg=#002b36 guibg=#fdf6e3
  elseif &background ==# 'light'
    " highlight Cursor ctermfg=15 ctermbg=4 guifg=#fdf6e3 guibg=#268bd2
    highlight Cursor ctermfg=15 ctermbg=0 guifg=#fdf6e3 guibg=#002b36
  endif
endfunction

" Show cursor line on active window only (or use InsertLeave/InsertEnter)
augroup ToggleCursorLine
  autocmd!
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END

" Restore cursor position and toggle cursor line
" Not needed with mkview/loadview
" https://github.com/farmergreg/vim-lastplace
" function! RestoreCursorPosition()
"   if &filetype ==# 'gitcommit'
"     return 0
"   endif
"   if line("'\"") > 0 && line("'\"") <= line('$')
"     normal! g`"
"     return 1
"   endif
" endfunction
" augroup RestoreCursorPosition
"   autocmd!
"   autocmd BufReadPost * call RestoreCursorPosition()
" augroup END

" Searching {{{1

" set gdefault " Reverse global flag (always apply to all, except if /g)
set hlsearch " Keep all matches highlighted when there is a previous search
set ignorecase " Ignore case in search patterns
" set magic " Changes the special characters that can be used in search patterns
set smartcase " Case sensitive when the search contains upper case characters

if has('reltime')
  set incsearch " Do incremental searching when it's possible to timeout
endif

" Indentation {{{1

set smarttab
set autoindent
" set smartindent " When starting a new line
set expandtab " Use spaces instead of tabs
set shiftround " >> indents to net multiple of 'shiftwidth'
set shiftwidth=4 " >> indents by 4 spaces
set softtabstop=4 " Number of spaces that a tab counts for while editing
set tabstop=4 " Spaces used to represent a tab (default: 8)

" Scrolling {{{1

set scrolloff=5 " Lines to keep above and below the cursor
set sidescroll=1 " Lines to scroll horizontally when 'wrap' is set
set sidescrolloff=5 " Lines to the left and right if 'nowrap' is set

" Folding {{{1

set nofoldenable
" set foldcolumn=1
" set foldlevelstart=10
set foldmethod=indent
set foldnestmax=3

" Columns {{{1

" exists('+colorcolumn')
set colorcolumn=+1 " Color column relative to textwidth
set number " Print the line number in front of each line
" set numberwidth=4 " Minimal number of columns to use for the line number
set relativenumber " Show the line number relative to the line with the cursor

" Command line {{{1

if &history < 1000
  set history=1000 " Keep 1000 lines of command line history
endif

set showcmd " Display incomplete commands
set noshowmode " Hide current mode in command line
set wildmenu " Display completion matches in a status line
set wildmode=longest,full " Complete longest common string, then each full match

" Status line {{{1

set display+=lastline " Display as much as possible of the last line
set display+=truncate " Show @@@ in the last line if it's truncated
set laststatus=2 " Always show statusline
set ruler " Always show current position
set rulerformat=%l,%c%V%=%P

" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" function! ShowFi() abort
"   let l:ft = &filetype
"   let l:bt = &buftype
"   return strlen(l:ft) && l:ft !=# 'netrw' && l:bt !=# 'help'
" endfunction
" set statusline=%<%f\ %m%r%w\ %=%{ShowFi()?(&fenc?&fenc:&enc.'['.&ff.']'):''}%{strlen(&ft)?&ft:&bt}\ %-14.(%l,%c%V/%L%)\ %P

" set statusline=%!status#Line()
let &g:statusline = status#Line()

function! HighlightStatusLine() abort
  if &background ==# 'dark'
    highlight StatusLineReverse term=reverse ctermfg=14 ctermbg=0
    " highlight StatusLineNormal ctermfg=0 ctermbg=4
    "term=reverse cterm=reverse ctermfg=14 ctermbg=0 gui=bold,reverse
    highlight StatusLineInsert cterm=NONE ctermfg=0 ctermbg=2 gui=NONE guifg=#073642 guibg=#859900
    highlight StatusLineReplace cterm=NONE ctermfg=0 ctermbg=9 gui=NONE guifg=#073642 guibg=#cb4b16
    highlight StatusLineVisual cterm=NONE ctermfg=0 ctermbg=3 gui=NONE guifg=#073642 guibg=#b58900
  elseif &background ==# 'light'
    highlight StatusLineReverse term=reverse ctermfg=10 ctermbg=7
    " highlight StatusLineNormal ctermfg=7 ctermbg=4
    "term=reverse cterm=reverse ctermfg=10 ctermbg=7 gui=bold,reverse
    highlight StatusLineInsert cterm=NONE ctermfg=7 ctermbg=2 gui=NONE guifg=#eee8d5 guibg=#859900
    highlight StatusLineReplace cterm=NONE ctermfg=7 ctermbg=9 gui=NONE guifg=#eee8d5 guibg=#cb4b16
    highlight StatusLineVisual cterm=NONE ctermfg=7 ctermbg=3 gui=NONE guifg=#eee8d5 guibg=#b58900
  endif
endfunction

" Tab line {{{1

" Plug 'webdevel/tabulous'

set showtabline=1

" Completion {{{1

set complete-=i " Do not scan current and included files
set complete+=kspell " Use the currently active spell checking
set completeopt+=longest " Only insert the longest common text of the matches

if exists('+omnifunc')
  augroup OmniCompletion
    autocmd!
    autocmd Filetype * if &omnifunc ==# "" | setlocal omnifunc=syntaxcomplete#Complete | endif
  augroup END
endif

" Abbreviations {{{1

function! Eatchar(pat)
  let l:c = nr2char(getchar(0))
  return (l:c =~ a:pat) ? '' : l:c
endfunc

iabbrev pyhton python

" Key bindings {{{1

" Commands {{{1

" Enable soft wrap (break lines without breaking words)
" command! -nargs=* Wrap setlocal wrap linebreak nolist
" command! -nargs=* CursorHi call HighlightCursor()

" command! -nargs=0 HexDump :%!xxd
" command! -nargs=0 HexRestore :%!xxd -r

" Autocommands {{{1

augroup VimInit
  autocmd!
  " Load status line at startup (after CtrlP)
  " autocmd VimEnter * :call colorscheme#Set('solarized8') | :call status#Colors()

  "autocmd VimEnter * :let &g:statusline = status#Line()
  " Reset colors persisting in terminal
  " autocmd VimLeave * :!echo -ne "\033[0m"

  " Override highlight groups when color scheme changes
  autocmd VimEnter,ColorScheme * :call HighlightCursor() | :call HighlightStatusLine()

  " Fix Neovim Lazy Redraw: https://github.com/neovim/neovim/issues/4884
  " autocmd FocusLost * :set nolazyredraw
  " autocmd FocusGained * :redrawstatus
  " autocmd VimResized * :redrawstatus

  " autocmd BufReadPost,FileReadPost *.py :silent %!PythonTidy.py
  " autocmd BufReadPost,FileReadPost *.p[lm] :silent %!perltidy -q
  " autocmd BufReadPost,FileReadPost *.xml :silent %!xmlpp -t -c -n
  " autocmd BufReadPost,FileReadPost *.[ch] :silent %!indent

  " Comments string
  autocmd FileType cfg,inidos setlocal commentstring=#\ %s
  autocmd FileType xdefaults setlocal commentstring=!\ %s

  " Auto reload vimrc on save
  autocmd BufWritePost $MYVIMRC nested source %
  " autocmd BufEnter *.vim.local :setlocal filetype=vim
augroup END

" }}}

call init#Source('~/.vimrc.local')
" if filereadable($HOME . '/.vimrc.local')
"   source ~/.vimrc.local
" endif

" vim: et sts=2 sw=2 ts=2 foldenable foldmethod=marker
