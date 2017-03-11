" Vim

" zi Folding on/off
" zR Open all
" zM Close all
" za Toggle current
" zj Down to the start of the next
" zk Up to the end of the previous

" runtime before.vim

" Plugins {{{1

let g:vim_plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let g:vim_plug_path = $HOME . '/.vim/autoload/plug.vim'
let g:vim_plugins_path = $HOME . '/.vim/plugins'
let g:vim_packages_path = $HOME . '/.vim/packages'

let $PLUGINS = g:vim_plugins_path

" Auto download vim-plug and install plugins
if empty(glob(g:vim_plug_path)) " !isdirectory(g:vim_plugins_path)
  " echo 'Installing Vim-Plug...'
  execute 'silent !curl -fLo ' . g:vim_plug_path . '  --create-dirs ' . g:vim_plug_url
  augroup VimPlug
    autocmd!
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  augroup END
endif

" Start Vim Plug
call plug#begin(g:vim_plugins_path)

" Register plugins
runtime plug.vim
for s:path in split(globpath(g:vim_packages_path, '*.vim'), '\n')
  let s:name = fnamemodify(s:path, ':t:r')
  " Skip explicitly disabled plugins
  if exists('g:enable_' . s:name) && g:enable_{s:name} == 0
    continue
  endif
  execute 'source ' . s:path
endfor

" Add plugins to &runtimepath
call plug#end()

" Load matchit.vim
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &runtimepath) ==# ''
  runtime! macros/matchit.vim
endif

" General {{{1

if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" Options {{{1

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif

set timeout
set timeoutlen=1000
set nottimeout
" set ttimeoutlen=-1

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

set nrformats-=octal " Disable octal format for number processing using CTRL-A

set backspace=indent,eol,start " Normal backspace in insert mode

set nostartofline " Keep the cursor on the same column if possible

set lazyredraw " Redraw only if necessary, faster macros

" set esckeys " Recognize escape immediately

set exrc " Enable per-directory .vimrc files
set secure " Disable unsafe commands

set modeline " Allow setting some options at the beginning and end of the file
set modelines=2 " Number of lines checked for set commands

" set title " Set the title of the window to 'titlestring'

" set fileformats=unix,dos,mac " Use Unix as the standard file type

set clipboard=unnamed " Use system clipboard

set synmaxcol=420 " Limit syntax highlighting for long lines

set report=0 " Always report changed lines (default threshold: 2)

set autoread " Reload unmodified files when changes are detected outside

" set autowrite " Automatically :write before running commands

set hidden " Allow modified buffers in the background

set splitbelow " Split windows below the current window

set splitright " Split windows right of the current window

set diffopt+=vertical " Always use vertical diffs

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

if &history < 1000
  set history=1000
endif

if &tabpagemax < 50
  set tabpagemax=50
endif

if !empty(&viminfo)
  set viminfo^=!
endif

set sessionoptions-=options

" Mouse {{{1

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

" Completion {{{1

" set complete-=i " Do not scan current and included files

set complete+=kspell " Autocompete with dictionnary words when spell check is on

set completeopt+=longest,menuone " Only insert the longest common text for matches

" Search {{{1

set incsearch

set hlsearch " Keep matches highlighted

set ignorecase " Ignore case in search patterns

set smartcase " Do not ignore when the pattern containes upper case characters

" set magic " Changes the special characters that can be used in search patterns

" set gdefault " Reverse global flag: always apply to all, except if /g


" Indentation {{{1

set smarttab
set autoindent
" set smartindent " When starting a new line
set expandtab " Use spaces instead of tabs
set shiftround " >> indents to net multiple of 'shiftwidth'
set shiftwidth=4 " >> indents by 4 spaces
set softtabstop=-1 " Use 'shiftwidth' value for editing operations
set tabstop=4 " Spaces used to represent a tab (default: 8)

" Scrolling {{{1

set scrolloff=3 " Lines to keep above and below the cursor
set sidescroll=1 " Lines to scroll horizontally when 'wrap' is set
set sidescrolloff=5 " Lines to the left and right if 'nowrap' is set

" Folding {{{1

" set foldcolumn=1
set foldmethod=indent
set foldnestmax=3
set nofoldenable

" Status line {{{1

set laststatus=2 " Always show statusline

set display+=lastline " Display as much as possible of the last line

set noshowmode " Do not display current mode

set showcmd " Display incomplete commands

set ruler " Always show current position

" set rulerformat=%l,%c%V%=%P

" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

set statusline=%!statusline#Build()

set wildmenu " Invoke completion on <Tab> in command line mode

set wildmode=longest,full " Complete longest common string, then each full match

" Characters {{{1

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

" Term colors {{{1

if &term =~# '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Allow color schemes to do bright colors without forcing bold
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" Columns {{{1

set number " Print the line number in front of each line

" set numberwidth=4 " Minimal number of columns to use for the line number

set relativenumber " Show the line number relative to the line with the cursor

" Relative to textwidth
if exists('+colorcolumn')
  set colorcolumn=+1
endif

" Bells {{{1

set noerrorbells " Disable audible bell for error messages
set visualbell " Use visual bell instead of beeping
set t_vb= " Disable audible and visual bells

" Abbreviations {{{1

iabbrev cl! console.log( )<Left><Left>
iabbrev vd! var_dump( )<Left><Left>

iabbrev pyhton python

" Key bindings {{{1

" Yank from the cursor to the end of the line
noremap Y y$

" Visually select the text that was last edited/pasted
noremap gV `[v`]

" Intuitive movement on wrapped lines
nnoremap j gj
nnoremap k gk
" nnoremap 0 g0
" nnoremap $ g$ " Do not use with :set wrap

" Restore visual selection after indent (breaks '.' dot repeat)
" vnoremap < <gv
" vnoremap > >gv

" Split navigation shortcuts
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Bubble single or multiple lines
noremap <C-Up> ddkP
noremap <C-Down> ddp
vnoremap <C-Up> xkP`[V`]
vnoremap <C-Down> xp`[V`]

" Paragraph reflow according to textwidth?
" vnoremap Q gv
" noremap Q gqap

" Clear highlighted search results (vim-sensible: Ctrl-L)
nnoremap <Space> :nohlsearch<CR>

" Repeat latest f, t, F or T [count] times
noremap <Tab> ;

" Repeat last command on next match
noremap ; :normal n.<CR>

" Edit in the same directory as the current file :e %%
cnoremap <expr> %% getcmdtype() == ':' ? fnameescape(expand('%:h')) . '/' : '%%'

" Use <Left> and <Right> keys to move the cursor
" instead of selecting a different match:
" cnoremap <Left> <Space><BS><Left>
" cnoremap <Right> <Space><BS><Right>

" Save as root with :w!!
if exists(':SudoWrite') == 1
  cnoremap w!! SudoWrite
else
  cnoremap w!! w !sudo tee % >/dev/null
endif

function! OnlyWS() abort
  " let l:col = col('.') - 1
  " " !col || getline('.')[col - 1] !~ '\k'
  " return !l:col || getline('.')[l:col - 1] =~# '\s'
  return strpart( getline('.'), 0, col('.')-1 ) =~# '^\s*$'
endfunction

function! NextComp() abort
  " if !pumvisible()
  "   return ''
  " endif
  " TODO omnifunc, ...
  return "\<C-p>" " Nearest matching word
endfunction

function! PrevComp() abort
  return "\<C-n>"
endfunction

" Next and previous completion Tab and Shift-Tab
inoremap <expr> <Tab> OnlyWS() ? "\<Tab>" : NextComp()
" inoremap <S-Tab> <C-p> " Fix Shift-Tab? :exe 'set t_kB=' . nr2char(27) . '[Z'
inoremap <expr> <S-Tab> OnlyWS() ? "\<S-Tab>" : PrevComp()

" " Select the completed word with Enter
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" inoremap <CR> <C-r>=<SID>cr_close_popup()<CR>
" " Close the popup menu (using <Esc> or <CR> breaks enter and arrow keys)
" inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<CR>"

" Use <C-c> to stop the highlighting for the 'hlsearch' option
if maparg('<C-c>', 'n') ==# ''
  nnoremap <silent> <C-c> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Change leader
let g:mapleader = "\<Space>"

" Sort selection
noremap <Leader>s :sort<CR>

" Quicker quit
noremap <Leader>q :q<CR>

" Save a file
noremap <Leader>w :w<CR>

" Write as root
noremap <Leader>W :w!!<CR>

" Commands {{{1

" Quick spell lang switch
command! En setlocal spelllang=en
command! Fr setlocal spelllang=fr

" Use 'Spell <lang>' to enable spell checking in the current buffer
command! -nargs=1 -complete=custom,ListLangs Spell setlocal spell spelllang=<args>
function! ListLangs(ArgLead, CmdLine, CursorPos) abort
  let l:list = ['en', 'fr']
  return join(l:list, "\n")
endfunction

" Enable soft wrap (break lines without breaking words)
" command! -nargs=* Wrap setlocal wrap linebreak nolist

" 1}}}

" set omnifunc=syntaxcomplete#Complete

" augroup VIMRC
"   autocmd!
"   autocmd ColorScheme * redraw | autocmd! VIMRC
" augroup END

if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif

" vim: foldenable foldmethod=marker et sts=2 sw=2 ts=2
