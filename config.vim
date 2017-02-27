" Main configuration

if &term =~# '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

if !has('nvim')
  " Fix mouse inside screen and tmux
  if &term =~# '^screen' || strlen($TMUX) > 0
    set ttymouse=xterm2
  endif
  " Fast terminal connection
  set ttyfast
endif

if has('mouse')
  set mouse+=a
endif

" Use Unix as the standard file type
" set fileformats=unix,dos,mac

" Use system clipboard
set clipboard=unnamed

" Relative to textwidth
if exists('+colorcolumn')
  set colorcolumn=+1
endif

set number
if exists('&relativenumber')
  set relativenumber
endif

" Syntax highlight limit
set synmaxcol=500

" Allow modified buffers in the background
set hidden

" Display current mode in status line
set showmode

" Display incomplete commands
set showcmd

" Highlight previous matches
set hlsearch

" Ignore case in search patterns
set ignorecase

" Do not ignore when the pattern containes upper case characters
set smartcase

" Indentation
if !exists('g:loaded_sleuth')
  set expandtab
  set shiftwidth=4
  set softtabstop=4
  set tabstop=4
endif

" Show invisible characters
set list
" set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
let &listchars = 'tab:' . nr2char(0x25B8) . ' '
let &listchars.= ',trail:' . nr2char(0x00B7)
let &listchars.= ',extends:' . nr2char(0x276F)
let &listchars.= ',precedes:' . nr2char(0x276E)
let &listchars.= ',nbsp:' . nr2char(0x005F)
let &listchars.= ',eol:' . nr2char(0x00AC)

" Folding
" " set foldcolumn=1
" set foldmethod=indent
" set foldnestmax=3
" set nofoldenable

" Always use vertical diffs
set diffopt+=vertical
