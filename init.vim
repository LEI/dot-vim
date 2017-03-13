" Vim

" zi Folding on/off
" zR Open all
" zM Close all
" za Toggle current
" zj Down to the start of the next
" zk Up to the end of the previous

" runtime before.vim

" Plugins {{{1

let $PLUGINS = g:package#plugins_dir

" Start Vim Plug
call package#Begin()
" Register plugins
call package#Plug()
" Add plugins to &runtimepath
call package#End()

" Load matchit.vim
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &runtimepath) ==# ''
  runtime! macros/matchit.vim
endif

" Options {{{1

if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

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

set complete-=i " Do not scan current and included files

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

" Mouse support {{{1

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

set display+=lastline " Display as much as possible of the last line
set laststatus=2 " Always show statusline
set ruler " Always show current position
" set rulerformat=%l,%c%V%=%P
set showcmd " Display incomplete commands
" set showmode " Display current mode in command line
set wildmenu " Invoke completion on <Tab> in command line mode
set wildmode=longest,full " Complete longest common string, then each full match
if &statusline ==# '' " set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
  function! ShowFi() abort " Show file info (encoding and format)
    let l:ft = &filetype
    let l:bt = &buftype
    return strlen(l:ft) && l:ft !=# 'netrw' && l:bt !=# 'help'
  endfunction
  set statusline=%<%f\ %m%r%w\ %=%{ShowFi()?(&fenc?&fenc:&enc.'['.&ff.']'):''}%([%{strlen(&ft)?&ft:&bt}]%)\ %-14.(%l,%c%V/%L%)\ %P
endif

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
else " let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+ " ,eol:$
endif

" " let &showbreak = '-> '
" if has('multi_byte') && &encoding ==# 'utf-8'
"   " Show line breaks (arrows: 0x21AA or 0x08627)
"   let &showbreak = nr2char(0x2026) " Ellipsis
" endif

" Term colors {{{1

" Disable Background Color Erase (BCE) so that color schemes
" work properly when Vim is used inside tmux and GNU screen.
" See also http://snk.tuxfamily.org/log/vim-256color-bce.html
" if &term =~# '256color'
"   set t_ut=
" endif

" " Allow color schemes to do bright colors without forcing bold
" if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
"   set t_Co=16
" endif

" Enable true colors in the terminal
let g:vim_true_color = has('nvim') || v:version > 740 || v:version == 740 && has('patch1799')
let g:term_true_color = $COLORTERM ==# 'truecolor' || $COLORTERM =~# '24bit'
  \ || $TERM_PROGRAM ==# 'iTerm.app' " $TERM ==# 'rxvt-unicode-256color'

if get(g:, 'vim_true_color', 0) && get(g:, 'term_true_color', 0) " Apple_Terminal
  set termguicolors
  " :h xterm-true-color
  " let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
  " let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
  if !has('nvim') && $TERM ==# 'screen-256color'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
endif

" set t_AB=^[[48;5;%dm
" set t_AF=^[[38;5;%dm

" Columns {{{1

if exists('+colorcolumn')
  set colorcolumn=+1 " Color column relative to textwidth
endif
set number " Print the line number in front of each line
" set numberwidth=4 " Minimal number of columns to use for the line number
set relativenumber " Show the line number relative to the line with the cursor

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

" Use <Left> and <Right> keys to move the cursor in ':' command mode
" instead of selecting a different match, as <Tab> / <S-Tab> does
cnoremap <expr> <Left> getcmdtype() == ':' ? "\<Space>\<BS>\<Left>" : "\<Left>"
cnoremap <expr> <Right> getcmdtype() == ':' ? "\<Space>\<BS>\<Right>" : "\<Right>"

" Save as root with :w!!
"cnoremap <expr> w!! (exists(':SudoWrite') == 2 ? "SudoWrite" : "w !sudo tee % >/dev/null") . "\<CR>"
cnoremap w!! w !sudo tee % > /dev/null
" command W w !sudo tee % > /dev/null

" Use <C-c> to stop the highlighting for the 'hlsearch' option
if maparg('<C-c>', 'n') ==# ''
  nnoremap <silent> <C-c> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-c>
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

" Background and theme switcher (requires solarized8)
nnoremap <F5> :call colorscheme#ToggleBackground()<CR>
nnoremap <F4> :<C-u>call Solarized8Contrast(-v:count1)<CR>
nnoremap <F6> :<C-u>call Solarized8Contrast(+v:count1)<CR>

function! Solarized8Contrast(delta) abort
  let l:schemes = map(['_low', '_flat', '', '_high'], "'solarized8_'.(&background).v:val")
  exe 'colorscheme' l:schemes[((a:delta+index(l:schemes, g:colors_name)) % 4 + 4) % 4]
endfunction

" Auto commands {{{1

augroup VimInit
  autocmd!
  autocmd VimEnter * call colorscheme#Set('solarized8')
  autocmd VimEnter,ColorScheme * call s:highlight(&background)
  " Auto reload vimrc on save
  autocmd BufWritePost $MYVIMRC nested source %
  " autocmd ColorScheme * redraw

  " Fix Neovim Redraw: https://github.com/neovim/neovim/issues/4884
  autocmd FocusLost * redraw
  " autocmd FocusGained * set lazyredraw
  " autocmd VimResized * redrawstatus

  " autocmd BufReadPost,FileReadPost *.py :silent %!PythonTidy.py
  " autocmd BufReadPost,FileReadPost *.p[lm] :silent %!perltidy -q
  " autocmd BufReadPost,FileReadPost *.xml :silent %!xmlpp -t -c -n
  " autocmd BufReadPost,FileReadPost *.[ch] :silent %!indent
augroup END

" Set custom highlight groups
function! s:highlight(bg) abort
  if a:bg ==# 'dark'
    " highlight Cursor ctermfg=8 ctermbg=4 guifg=#002b36 guibg=#268bd2
    highlight Cursor ctermfg=0 ctermbg=15 guifg=#002b36 guibg=#fdf6e3
  elseif a:bg ==# 'light'
    " highlight Cursor ctermfg=15 ctermbg=4 guifg=#fdf6e3 guibg=#268bd2
    highlight Cursor ctermfg=15 ctermbg=0 guifg=#fdf6e3 guibg=#002b36
  endif
endfunction

" Commands {{{1

" Enable soft wrap (break lines without breaking words)
" command! -nargs=* Wrap setlocal wrap linebreak nolist

" }}}

if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif

" vim: foldenable foldmethod=marker et sts=2 sw=2 ts=2
