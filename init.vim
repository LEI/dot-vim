" Vim

" zi Folding on/off
" zR Open all
" zM Close all
" za Toggle current
" zj Down to the start of the next
" zk Up to the end of the previous

" let $VIMHOME = split(&runtimepath, ',')[0] " $HOME . '/.vim'
let $VIMHOME = fnamemodify(expand('<sfile>'), ':h')

" let g:plug_home = $VIMHOME . '/plugged'
let g:plug_path = $VIMHOME . '/autoload/plug.vim'
let g:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if empty(glob(g:plug_path))
  " confirm('Install Vim Plug?', "&Yes\n&No") == 1
  execute 'silent !curl -sfLo ' . g:plug_path . ' --create-dirs ' . g:plug_url
  let g:plug_install = 1
endif

call plug#begin() " Start Vim Plug
call config#Source($VIMHOME . '/config.vim')
call config#SourceDir($VIMHOME . '/config', 'config#Enabled')
call plug#end() " Add plugins to &runtimepath

" Clone and configure plugins once loaded
function! s:config()
  if get(g:, 'plug_install', 0)
    PlugInstall --sync
    let g:plug_install = 0
  endif
  if get(g:, 'loaded_plug', 0) && exists('#User#Config')
    doautocmd User Config
  endif
endfunction

augroup InitConfig
  autocmd!
  " Wait until vim is ready, or :PlugInstall will create the first window
  autocmd VimEnter * :call s:config() | autocmd! InitConfig
augroup END

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
" set noshowmatch " Don't show matching brackets when text indicator is over them

" set matchtime=2 " How many tenths of a second to blink when matching brackets

" set matchpairs+=<:> " HTML brackets

" set title " Set the title of the window to 'titlestring'

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
  if !isdirectory(g:undodir)
    call Mkdir(g:undodir)
  endif
  let &undodir = g:undodir
  set undofile
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

" Spaces and tabs {{{1

set smarttab
set autoindent
" set smartindent " When starting a new line
set expandtab " Use spaces instead of tabs
set shiftround " >> indents to net multiple of 'shiftwidth'
set shiftwidth=4 " >> indents by 4 spaces
set softtabstop=4 " Number of spaces that a tab counts for while editing
set tabstop=4 " Spaces used to represent a tab (default: 8)

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

" " Show line breaks (arrows: 0x21AA or 0x08627)
" let &showbreak = nr2char(0x2026) " Ellipsis

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

set complete-=i " Don't scan current and included files
set complete+=kspell " Use the currently active spell checking
" set completeopt+=longest " Only insert the longest common text of the matches

" Command line {{{1

if &history < 1000
  set history=1000 " Keep 1000 lines of command line history
endif
set report=0 " Always report changed lines (default threshold: 2)
set showcmd " Display incomplete commands
" set showmode " Show current mode in command line

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

" Leader mappings {{{1

" Change leader
let g:mapleader = "\<Space>"
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

" CTRL-U in insert mode deletes a lot: use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break
inoremap <C-U> <C-G>u<C-U>

" Paragraph reflow according to textwidth?
" noremap Q gqap
" vnoremap Q gv

" Make 'dot' work as expected in visual mode
" vnoremap . :norm.<CR>

" Yank from the cursor to the end of the line
noremap Y y$

" Visually select the text that was last edited/pasted
noremap gV `[v`]

" Move on virtual lines (wrapped) unless a count is specified
" To add j/k motions to the jump list: (v:count > 1 ? "m'" . v:count : '') . 'j/k'
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Move horizontally on virtual lines only when 'wrap' is on
nnoremap <expr> 0 !&wrap ? '0' : 'g0'
nnoremap <expr> $ !&wrap ? '$' : 'g$'

" Restore visual selection after indent (breaks '.' dot repeat)
" vnoremap < <gv
" vnoremap > >gv

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

" Repeat latest f, t, F or T [count] times
noremap <Tab> ;

" Repeat last command on next match
noremap ; :normal n.<CR>

" Remove trailing spaces
noremap _$ :call StripTrailingWhitespaces()<CR>

" Indent the whole file
noremap _= :call Preserve('normal gg=G')<CR>

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

" Make last typed word uppercase
inoremap <Plug>UpCase <Esc>hgUawea
imap ;u <Plug>UpCase

" Abbreviations {{{1

" Insert today's date
iabbrev <expr> ddate strftime("%b %d - %a")

" Commands {{{1

command! -nargs=0 -bar Install PlugInstall
command! -nargs=0 -bar Update PlugUpdate
command! -nargs=0 -bar Upgrade PlugUpgrade | PlugUpdate!

" Enable soft wrap (break lines without breaking words)
" command! -nargs=* Wrap setlocal wrap linebreak nolist

" command! -nargs=0 HexDump :%!xxd
" command! -nargs=0 HexRest :%!xxd -r

" 1}}}

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

  autocmd BufWritePre *.js,*.php,*.py :call StripTrailingWhitespaces()
  " au BufWritePost ~/.Xdefaults redraw | echo system('xrdb ' . expand('<amatch>'))
augroup END

call config#Source($HOME . '/.vimrc.local')

" vim: et sts=2 sw=2 ts=2 foldenable foldmethod=marker
