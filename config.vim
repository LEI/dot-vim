" Main options

if &term =~# '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Allow color schemes to do bright colors without forcing bold
" if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
"   set t_Co=16
" endif

if !has('nvim')
  " Fix mouse inside screen and tmux
  if &term =~# '^screen' || strlen($TMUX) > 0
    set ttymouse=xterm2
  endif
  " Faster terminal redrawing
  set ttyfast
endif

set lazyredraw " Only redraw when necessary

set backspace=indent,eol,start " Normal backspace in insert mode

set esckeys " Recognize escape immediately

set nostartofline " Keep the cursor on the same column if possible

" Enable per-directory .vimrc files and disable unsafe commands in them
" set exrc
" set secure

" set modeline " Allow setting some options at the beginning and end of the file
" set modelines=2 " Number of lines checked for set commands

" set title " Set the title of the window to 'titlestring'

" set complete-=i " Do not scan included files (ctags?)

" set complete+=kspell " Autocompete with dictionnary words when spell check is on

" set nrformats-=octal " Disable octal format for number processing using CTRL-A

if has('mouse')
  set mouse+=a
endif

" set fileformats=unix,dos,mac " Use Unix as the standard file type

set clipboard=unnamed " Use system clipboard

" Relative to textwidth
if exists('+colorcolumn')
  set colorcolumn=+1
endif

set number
if exists('&relativenumber')
  set relativenumber
endif

set synmaxcol=420 " Only highlight the first columns

" set report=0 " Always report changed lines

set autoread " Reload unmodified files when changes are detected outside

set hidden " Allow modified buffers in the background

set hlsearch " Keep matches highlighted

set ignorecase " Ignore case in search patterns

set smartcase " Do not ignore when the pattern containes upper case characters

" set smartindent " Smart autoindenting when starting a new line

" set magic " Changes the special characters that can be used in search patterns

" set gdefault

set splitbelow " Open new split panes below the current window

set splitright " Open new split panes right of the current window

set diffopt+=vertical " Always use vertical diffs

" set wildmenu " Invoke completion on <Tab> in commande line mode
" set wildmode=longest,full " Complete longest common string, then each full match

set shortmess=atI " Avoid hit-enter prompts caused by file messages

set noerrorbells " Disable audible bell for error messages
set visualbell " Use visual bell instead of beeping
set t_vb= " Disable audible and visual bells
"
" set noshowmatch " Do not show matching brackets when text indicator is over them

" set matchpairs+=<:> " HTML brackets

" set mat=2 " How many tenths of a second to blink when matching brackets

" Show line breaks (arrows: 0x21AA or 0x08627)
let &showbreak = nr2char(0x2026) " Ellipsis

" set fillchars+=stl:\ ,stlnc:\
" let &fillchars='vert:|,fold:-,stl:x,stlnc:y'

set list " Show invisible characters

" Vim: eol:$
" Nvim: tab:>\ ,trail:-,nbsp:+
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:' . nr2char(0x25B8) . ' '
  let &listchars.= ',trail:' . nr2char(0x00B7)
  let &listchars.= ',extends:' . nr2char(0x276F)
  let &listchars.= ',precedes:' . nr2char(0x276E)
  let &listchars.= ',nbsp:' . nr2char(0x005F)
  let &listchars.= ',eol:' . nr2char(0x00AC)
else
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  " let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

" Indentation
if !exists('g:loaded_sleuth')
  set expandtab " Use spaces instead of tabs
  set shiftwidth=4 " >> indents by 4 spaces
  set shiftround " >> indents to net multiple of 'shiftwidth'
  set softtabstop=4 " Tab key indents by 4 spaes
  " set tabstop=4
endif

" Folding
" " set foldcolumn=1
" set foldmethod=indent
" set foldnestmax=3
" set nofoldenable
