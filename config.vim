" Main vim options

" Colorscheme
try
  set background=dark
  colorscheme flattened_dark
  if exists('*strftime')
    let s:hour = strftime('%H')
    if s:hour > 7 && s:hour < 20
      set background=light
      colorscheme flattened_light
    endif
  endif
  " colorscheme solarized
  " call togglebg#map('<F5>')
catch /E185:/
  " colorscheme default
endtry

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

if has('mouse')
  set mouse+=a
endif

set backspace=indent,eol,start " Normal backspace in insert mode

set nostartofline " Keep the cursor on the same column if possible

set lazyredraw

" set esckeys " Recognize escape immediately
" set timeout
" set timeoutlen=1000
" set nottimeout
" set ttimeoutlen=-1

set exrc " Enable per-directory .vimrc files
set secure " Disable unsafe commands

" set modeline " Allow setting some options at the beginning and end of the file
set modelines=2 " Number of lines checked for set commands

" set title " Set the title of the window to 'titlestring'

" set nrformats-=octal " Disable octal format for number processing using CTRL-A

" set fileformats=unix,dos,mac " Use Unix as the standard file type

set clipboard=unnamed " Use system clipboard

set synmaxcol=420 " Limit syntax highlighting for long lines

set report=0 " Always report changed lines (default threshold: 2)

set autoread " Reload unmodified files when changes are detected outside

" set autowrite " Automatically :write before running commands

set hidden " Allow modified buffers in the background

set hlsearch " Keep matches highlighted

set ignorecase " Ignore case in search patterns

set smartcase " Do not ignore when the pattern containes upper case characters

" set smartindent " Smart autoindenting when starting a new line

" set magic " Changes the special characters that can be used in search patterns

" set gdefault " Reverse global flag (always apply to  all, except if /g)

set splitbelow " Split windows below the current window

set splitright " Split windows right of the current window

set wildmenu " Invoke completion on <Tab> in commande line mode

set wildmode=longest,full " Complete longest common string, then each full match

" set complete-=i " Do not scan current and included files

set complete+=kspell " Autocompete with dictionnary words when spell check is on

set completeopt+=longest " Only insert the longest common text for matches

set diffopt+=vertical " Always use vertical diffs

set shortmess=atI " Avoid hit-enter prompts caused by file messages

set noerrorbells " Disable audible bell for error messages
set visualbell " Use visual bell instead of beeping
set t_vb= " Disable audible and visual bells
"
" set noshowmatch " Do not show matching brackets when text indicator is over them

" set matchtime=2 " How many tenths of a second to blink when matching brackets

" set matchpairs+=<:> " HTML brackets

set formatoptions-=o " Disable automatic comment after hitting 'o' or 'O'

set nojoinspaces " Insert only one space after punctuation

set number " Print the line number in front of each line
" set numberwidth=4 " Minimal number of columns to use for the line number
set relativenumber " Show the line number relative to the line with the cursor

" Relative to textwidth
if exists('+colorcolumn')
  set colorcolumn=+1
endif

set nowrap " Do not wrap by default

set scrolloff=3 " Minimal number of screen lines to keep above and below the cursor
set sidescroll=1 " Minimal number to scroll horizontally when 'wrap' is set
set sidescrolloff=5 " Minimum number to the left and right if 'nowrap' is set

" Indentation
set expandtab " Use spaces instead of tabs
set shiftround " >> indents to net multiple of 'shiftwidth'
set shiftwidth=4 " >> indents by 4 spaces
set softtabstop=-1 " Use 'shiftwidth' value for editing operations
set tabstop=4 " Number of spaces used to represent a tab (default: 8)

" Default: set fillchars=stl:^,stlnc:=,vert:\|,fold:-,diff:-
" let &fillchars='stl: ,stlnc: '

set list " Show invisible characters

if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:' . nr2char(0x25B8) . ' '
    \ . ',trail:' . nr2char(0x00B7)
    \ . ',extends:' . nr2char(0x276F)
    \ . ',precedes:' . nr2char(0x276E)
    \ . ',nbsp:' . nr2char(0x005F)
    \ . ',eol:' . nr2char(0x00AC)
  " Show line breaks (arrows: 0x21AA or 0x08627)
  let &showbreak = nr2char(0x2026) " Ellipsis
else
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+ " ,eol:$
  " let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
  " let &showbreak = '-> '
endif

" Folding
" " set foldcolumn=1
" set foldmethod=indent
" set foldnestmax=3
" set nofoldenable

" augroup VIMRC
"   autocmd!
"   autocmd ColorScheme * redraw | autocmd! VIMRC
" augroup END

" Enable omni completion
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
