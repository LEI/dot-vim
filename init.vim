" Vim

" zi Folding on/off
" zR Open all
" zM Close all
" za Toggle current
" zj Down to the start of the next
" zk Up to the end of the previous

" if v:progname =~? 'evim' | finish | endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Plugins {{{1

let $VIMHOME = fnamemodify(expand('<sfile>'), ':h')
" split(&runtimepath, ',')[0] " $HOME . '/.vim'
call config#Init($VIMHOME, 'config')

" Load matchit.vim
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &runtimepath) ==# ''
  runtime! macros/matchit.vim
endif

if has('autocmd')
  filetype plugin indent on " Enable file type detection
endif

" Options {{{1

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

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if has('syntax') && &t_Co > 2 || has('gui_running')
  if !exists('g:syntax_on')
    syntax enable
  endif
  " let c_comment_string=1 " Highlight strings inside C comments
  set synmaxcol=420 " Limit syntax highlighting for long lines
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a mapping
  " If set (default), this may break plugins but it's backward compatible
  set nolangremap
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags; " Filenames for the tag command
endif

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif

if !empty(&viminfo)
  set viminfo^=!
endif

set nrformats-=octal " Disable octal format for number processing using Ctrl-A and Ctrl-X

" set fileformats=unix,dos,mac " Use Unix as the standard file type

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j " Delete comment character when joining commented lines
endif

set nojoinspaces " Insert only one space after a '.', '?' and '!' with a join command
"
" set noshowmatch " Don't show matching brackets when text indicator is over them

" set matchtime=2 " How many tenths of a second to blink when matching brackets

" set matchpairs+=<:> " HTML brackets

set autoread " Reload unmodified files when changes are detected outside

" set autowrite " Automatically :write before running commands

set hidden " Allow modified buffers in the background

set shortmess=atI " Avoid hit-enter prompts caused by file messages
" a  enable all abbreviations of message (flags: filmnrwx)
" t  truncate file message at the start when necessary
" I  don't give the intro message when starting

set nostartofline " Keep the cursor on the same column if possible

set lazyredraw " Redraw only if necessary, faster macros

set exrc " Enable per-directory .vimrc files
set secure " Disable unsafe commands

set modeline " Allow setting some options at the beginning and end of the file
set modelines=2 " Number of lines checked for set commands

" Clipboard adds a new line when yanking under Termux
set clipboard=unnamed " Use system clipboard

" Mouse {{{1

if has('mouse')
  set mouse=a
  " n  Normal mode
  " v  Visual mode
  " i  Insert mode
  " c  Command-line mode
  " h  all previous modes when editing a help file
  " a  all previous modes
  " r  for |hit-enter| and |more-prompt| prompt
endif

if has('mouse_xterm') && !has('nvim')
  " Fix mouse inside screen and tmux
  if &term =~# '^screen' || strlen($TMUX) > 0
    set ttymouse=xterm2
  endif
  " Faster terminal redrawing
  set ttyfast
endif

" Terminal colors {{{1

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

" Enable true color if supported (:h xterm-true-color)
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

" Don't save all options and mappings
set sessionoptions-=options

" Keep undo history across sessions
" expand(get(g:, 'undodir', '~/.vim/backups'))
let g:undodir = get(g:, 'undodir', $VIMHOME . '/backups')
if has('persistent_undo') " && exists('g:undodir')
  if !isdirectory(g:undodir)
    call Mkdir(g:undodir)
  endif
  " Enable undo files
  let &undodir = g:undodir
  set undofile
  " Disable swapfiles and backups
  set noswapfile " directory=~/.vim/swap
  set nobackup " backupdir=~/.vim/backup
  set nowritebackup
endif

" Windows {{{1

if has('windows')
  if &tabpagemax < 50
    set tabpagemax=50
  endif
  set winminheight=0 " Minimal height of a window when it's not the current one
endif

if has('title')
  " set title " Set the title of the window to 'titlestring'
  " set titlelen=85 " Percentage of 'columns' to use for the window title
  " set titleold= " Thanks\ for\ flying\ Vim
endif

if has('title') && has('statusline')
  " set titlestring=%<%F%=%l/%L-%P
  " set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
endif

" Searching {{{1

if has('extra_search')
  set hlsearch " Keep all matches highlighted when there is a previous search
endif
if has('reltime')
  set incsearch " Do incremental searching when it's possible to timeout
endif
" set gdefault " Reverse global flag (always apply to all, except if /g)
set ignorecase " Ignore case in search patterns
" set magic " Changes the special characters that can be used in search patterns
set smartcase " Case sensitive when the search contains upper case characters
set wrapscan " Searches wrap around the end of the file

" Spaces and tabs {{{1

set smarttab " Tab and backspace behave accordingly to 'sw', 'ts' or 'sts'
set autoindent " Copy indent from the current line when starting a new one
if has('smartindent')
  set smartindent " Automatically insert an indent in complement with 'autoindent'
endif

set expandtab " Use spaces instead of tabs
set shiftround " Round indent to multiple of 'shiftwidth'
set shiftwidth=4 " Number of spaces to use for each step of (auto)indent
set softtabstop=4 " Number of spaces that a tab counts for while editing
" set tabstop=8 " Number of spaces that a tab in the file counts for

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
endif

" Default: set fillchars=stl:^,stlnc:=,vert:\|,fold:-,diff:-
" let &fillchars='stl: ,stlnc: '

" Wrapping {{{1

set nowrap " Don't wrap lines by default

if has('linebreak')
  " Show line breaks (arrows: 0x21AA or 0x08627)
  "let &showbreak = nr2char(0x2026) " Ellipsis
endif

if exists('+colorcolumn')
  set colorcolumn=+1 " Color column relative to textwidth
endif

" Scrolling {{{1

set scrolloff=5 " Lines to keep above and below the cursor
set sidescroll=1 " Lines to scroll horizontally when 'wrap' is set
set sidescrolloff=5 " Lines to the left and right if 'nowrap' is set

" Folding {{{1

if has('folding')
  set nofoldenable
  " set foldcolumn=1
  " set foldlevelstart=10
  set foldmethod=indent
  set foldnestmax=3
endif

" Complete {{{1

set complete-=i " Don't scan current and included files
set complete+=kspell " Use the currently active spell checking
" set completeopt+=longest " Only insert the longest common text of the matches

" Command line {{{1

if &history < 1000
  set history=1000 " Keep more lines of command line history
endif
set report=0 " Always report changed lines (default threshold: 2)
set showcmd " Display incomplete commands
" set showmode " Show current mode in command line
if has('wildmenu')
  " set wildchar=<Tab>
  set wildmenu " Display completion matches in a status line
  set wildmode=longest,full " Complete longest common string, then each full match
  " if exists('&wildignorecase') | set wildignorecase | endif
endif

" Status line {{{1

set display+=lastline " Display as much as possible of the last line
try " v:version > 730?
  set display+=truncate " Display @@@ in the last line if it's truncated
catch
endtry
set laststatus=2 " Always show statusline
if has('cmdline_info')
  set ruler " Always show current position
endif
if has('statusline')
  " set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
  " set rulerformat=%l,%c%V%=%P
endif

" Leader mappings {{{1

" Change leader
let g:mapleader = "\<Space>"

" set pastetoggle=<Leader>p

" Switch between the current and previous buffer
nnoremap <Leader><Leader> <C-^>
" Find a loaded buffer
nnoremap <leader>b :b */*<C-d>
" Find a file in current working directory
nnoremap <leader>e :e **/*
" Sort selection
noremap <Leader>s :sort<CR>
" Quicker quit
noremap <Leader>q :q<CR>
" Save a file
noremap <Leader>w :w<CR>
" Write as root
noremap <Leader>W :w!!<CR>

" Key bindings {{{1

" Don't use Ex mode, use Q for formatting
map Q gq

" Yank from the cursor to the end of the line
noremap Y y$

" Visually select the text that was last edited/pasted
noremap gV `[v`]

" Move by rows instead of lines
" Unless a count is specified: nnoremap <expr> j v:count ? 'j/k' : 'gj/gk'
" To add j/k motions to the jump list: (v:count > 1 ? "m'" . v:count : '') . 'j/k'
nnoremap j gj
nnoremap k gk

" Reverse mappings to move linewise
nnoremap gj j
nnoremap gk k

" Horizontal movements on rows when 'wrap' is set
nnoremap <expr> 0 !&wrap ? '0' : 'g0'
nnoremap <expr> $ !&wrap ? '$' : 'g$'

" Repeat latest linewise character searches (f, t, F or T [count] times)
noremap <Tab> ;

" Repeat last command on next match
noremap ; :normal n.<CR>

" Split navigation shortcuts
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" Bubble single or multiple lines
noremap <C-Up> ddkP
noremap <C-Down> ddp
vnoremap <C-Up> xkP`[V`]
vnoremap <C-Down> xp`[V`]

" Maintain cursor position when joining lines
" nnoremap J mzJ`z

" Paragraph reflow according to textwidth?
" noremap Q gqap
" vnoremap Q gv

" Restore visual selection after indenting?
" vnoremap < <gv
" vnoremap > >gv

" Make 'dot' work as expected in visual mode
vnoremap . :norm.<CR>

" Stop the highlighting for the 'hlsearch' option and redraw the screen
nnoremap <silent> <Space> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
" if maparg('<C-L>', 'n') ==# ''
"   nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
" endif

" Edit in the same directory as the current file :e %%
cnoremap <expr> %% getcmdtype() ==# ':' ? fnameescape(expand('%:h')) . '/' : '%%'

" Use <Left> and <Right> keys to move the cursor in ':' command mode
" instead of selecting a different match, as <Tab> / <S-Tab> does
cnoremap <expr> <Left> getcmdtype() ==# ':' ? "\<Space>\<BS>\<Left>" : "\<Left>"
cnoremap <expr> <Right> getcmdtype() ==# ':' ? "\<Space>\<BS>\<Right>" : "\<Right>"

" Save current file as root with sudo
cnoremap w!! w !sudo tee % > /dev/null

" CTRL-U in insert mode deletes a lot: use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break
inoremap <C-U> <C-G>u<C-U>

" Remove trailing spaces in the current file
" noremap _$ :call StripTrailingWhitespace()<CR>

" Indent the whole file
" noremap _= :call Preserve('normal gg=G')<CR>

" Make last typed word uppercase by typing ';u'
" inoremap <Plug>UpCase <Esc>hgUawea
" imap ;u <Plug>UpCase

" Abbreviations {{{1

" Insert today's date
iabbrev <expr> ddate strftime("%b %d - %a")

" Commands {{{1

" Enable soft wrap (break lines without breaking words)
" command! -nargs=* Wrap setlocal wrap linebreak nolist

" command! -nargs=0 HexDump :%!xxd
" command! -nargs=0 HexRest :%!xxd -r

" Autocommands {{{1

augroup Config
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

" 1}}}

call config#Source($HOME . '/.vimrc.local')

" vim: et sts=2 sw=2 ts=2 foldenable foldmethod=marker
