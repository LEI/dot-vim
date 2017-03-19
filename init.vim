" Vim

" zi Folding on/off
" zR Open all
" zM Close all
" za Toggle current
" zj Down to the start of the next
" zk Up to the end of the previous

" Plugins {{{1

" let $VIMHOME = split(&runtimepath, ',')[0] " $HOME . '/.vim'
let $VIMHOME = fnamemodify(expand('<sfile>'), ':h')

" let g:plug_home = $VIMHOME . '/plugged'
let g:plug_path = $VIMHOME . '/autoload/plug.vim'
let g:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if empty(glob(g:plug_path))
  " confirm('Install Vim Plug in ' . g:plug_path . '?') == 1
  execute 'silent !curl -sfLo ' . g:plug_path . ' --create-dirs ' . g:plug_url
  let g:did_install = 0
endif

call plug#begin() " Start Vim Plug
call config#Source($VIMHOME . '/config.vim')
call config#SourceDir($VIMHOME . '/config', 'config#Enabled')
call plug#end() " Add plugins to &runtimepath

" Install plugins if Vim Plug has been downloaded
if get(g:, 'did_install', 1) == 0
  PlugInstall --sync | let g:did_install = 1 | source $MYVIMRC
endif

" Source files after loading enabled plugins
" call config#Source($VIMHOME . '/after.vim')
" call config#SourceDir($VIMHOME . '/after', 'config#Enabled')

" Load matchit.vim
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &runtimepath) ==# ''
  runtime! macros/matchit.vim
endif

" Options {{{1

set backspace=indent,eol,start " Allow backspace over everything in insert mode

" set esckeys " Recognize escape immediately

set timeout
set timeoutlen=1000
if !has('nvim')
  set ttimeout " Time out for key codes
  set ttimeoutlen=100 " Wait up to 100ms after Esc for special keys
endif

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if has('syntax')
  set synmaxcol=420 " Limit syntax highlighting for long lines
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

set nrformats-=octal " Disable octal format for number processing using Ctrl-A and Ctrl-X

" set fileformats=unix,dos,mac " Use Unix as the standard file type

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j " Delete comment character when joining commented lines
endif

set nojoinspaces " Insert only one space after punctuation
"
" set noshowmatch " Do not show matching brackets when text indicator is over them

" set matchtime=2 " How many tenths of a second to blink when matching brackets

" set matchpairs+=<:> " HTML brackets

" set title " Set the title of the window to 'titlestring'

set report=0 " Always report changed lines (default threshold: 2)

set autoread " Reload unmodified files when changes are detected outside

" set autowrite " Automatically :write before running commands

set hidden " Allow modified buffers in the background

set shortmess=atI " Avoid hit-enter prompts caused by file messages

set nostartofline " Keep the cursor on the same column if possible

set lazyredraw " Redraw only if necessary, faster macros

set exrc " Enable per-directory .vimrc files
set secure " Disable unsafe commands

set modeline " Allow setting some options at the beginning and end of the file
set modelines=2 " Number of lines checked for set commands

set nowrap " Do not wrap by default

if exists('+colorcolumn')
  set colorcolumn=+1 " Color column relative to textwidth
endif

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

" Color scheme {{{1

" set background=dark
" colorscheme spacegray

if exists('*Solarized8') | call Solarized8() | endif

" Bells {{{1

set noerrorbells " Disable audible bell for error messages
set visualbell " Use visual bell instead of beeping
set t_vb= " Disable audible and visual bells

" Sessions and views {{{1

" set viewdir=$HOME/.vim/view " Customize location of saved views
set viewoptions-=options " folds,options,cursor
" cursor: cursor position in file and in window
" folds: manually created folds, opened/closed folds and local fold options
" options: options and mappings local to a window or buffer (not global values for local options)
" localoptions: same as 'options'
" slash,unix: useful on Windows when sharing view files

set sessionoptions-=options

" Keep undo history across sessions
" expand(get(g:, 'undodir', '~/.vim/backups'))
let g:undodir = get(g:, 'undodir', $VIMHOME . '/backups')
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

" Complete {{{1

set complete-=i " Do not scan current and included files
set complete+=kspell " Use the currently active spell checking
set completeopt+=longest " Only insert the longest common text of the matches

" Nex completion with Tab
if maparg('<Tab>', 'i') ==# ''
  inoremap <expr> <Tab> CanComplete() ? "\<C-n>" : "\<Tab>"
endif

" Previous completion with Shift-Tab
if maparg('<S-Tab>', 'i') ==# ''
  " <S-Tab> :exe 'set t_kB=' . nr2char(27) . '[Z'
  inoremap <S-Tab> <C-p>
endif

" Check characters before the cursor
function! CanComplete() abort
  let l:col = col('.') - 1
  if !l:col || getline('.')[l:col - 1] !~# '\k'
    return 0
  endif
  return 1
endfunction

if exists('+omnifunc')
  augroup OmniCompletion
    autocmd!
    autocmd Filetype * if &omnifunc ==# "" | setlocal omnifunc=syntaxcomplete#Complete | endif
  augroup END
endif

" Command line {{{1

if &history < 1000
  set history=1000 " Keep 1000 lines of command line history
endif
set showcmd " Display incomplete commands

set wildmenu " Display completion matches in a status line
set wildmode=longest,full " Complete longest common string, then each full match

" Status line {{{1

if v:version > 730 " 800?
  set display+=truncate " Show @@@ in the last line if it's truncated
endif
set display+=lastline " Display as much as possible of the last line
set laststatus=2 " Always show statusline
set ruler " Always show current position
" set rulerformat=%l,%c%V%=%P
" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

if &statusline ==# ''
  set showmode " Show current mode in command line
  set statusline=%(%{&paste?'PASTE':''}\ %)
  set statusline+=%<%f\ %m%r%w%=
  set statusline+=%(\ %{FileInfo()}%)
  set statusline+=%(\ %{strlen(&ft)?&ft:&bt}%)
  set statusline+=\ %-14.(%l,%c%V/%L%)\ %P
  function! FileInfo() abort
    let l:str = ''
    let l:ft = &filetype
    let l:bt = &buftype
    if !(strlen(l:ft) && l:ft !=# 'netrw' && l:bt !=# 'help')
      return l:str
    endif
    let l:fe = strlen(&fileencoding) ? &fileencoding : &encoding
    let l:ff = &fileformat
    if has('+bomb') && &bomb
      let l:fe.= ',B'
    endif
    if l:fe !=# 'utf-8' | let l:str.= l:fe | endif
    if l:ff !=# 'unix' | let l:str.= '[' . l:ff . ']' | endif
    return l:str
  endfunction
endif

" 1}}}

augroup VimInit
  autocmd!

  " Reset colors persisting in terminal
  " autocmd VimLeave * :!echo -ne "\033[0m"

  " Fix Neovim Lazy Redraw: https://github.com/neovim/neovim/issues/4884
  " autocmd FocusLost * :set nolazyredraw
  " autocmd FocusGained * :redrawstatus
  " autocmd VimResized * :redrawstatus

  " autocmd BufReadPost,FileReadPost *.py :silent %!PythonTidy.py
  " autocmd BufReadPost,FileReadPost *.p[lm] :silent %!perltidy -q
  " autocmd BufReadPost,FileReadPost *.xml :silent %!xmlpp -t -c -n
  " autocmd BufReadPost,FileReadPost *.[ch] :silent %!indent
  " autocmd BufEnter *.vim.local :setlocal filetype=vim
augroup END

call config#Source($HOME . '/.vimrc.local')

" vim: et sts=2 sw=2 ts=2 foldenable foldmethod=marker
