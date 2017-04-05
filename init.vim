" Vim

" https://github.com/robertmeta/vimfiles/blob/master/vimrc

" zi Folding on/off
" zR Open all
" zM Close all
" za Toggle current
" zj Down to the start of the next
" zk Up to the end of the previous

" split(&runtimepath, ',')[0] " $HOME . '/.vim'
let $VIMHOME = fnamemodify(expand('<sfile>'), ':h')

" Vim defaults
call config#Source($VIMHOME . '/defaults.vim')

" Install Vim Plug
call config#Init()
" Initialize plugins
call config#Enable() " $VIMHOME . '/config'

" General {{{1

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if has('syntax')
  set synmaxcol=420 " Limit syntax highlighting for long lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags; " Filenames for the tag command
endif

if !empty(&viminfo)
  set viminfo^=!
endif

" set formatoptions-=o " Disable automatic comments when hitting 'o' or 'O'
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

" Cursor {{{1

if has('syntax')
  set cursorline " Highlight the screen line of the cursor
endif
set nostartofline " Keep the cursor on the same column when possible
set scrolloff=5 " Lines to keep above and below the cursor
set sidescroll=1 " Lines to scroll horizontally when 'wrap' is set
set sidescrolloff=5 " Lines to the left and right if 'nowrap' is set

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

" Enable true color if supported (:h xterm-true-color)
" http://sunaku.github.io/tmux-24bit-color.html#usage
let g:term_true_color = $COLORTERM ==# 'truecolor' || $COLORTERM =~# '24bit'
      \ || $TERM_PROGRAM ==# 'iTerm.app' " $TERM ==# 'rxvt-unicode-256color'
" has('nvim') || v:version > 740 || v:version == 740 && has('patch1799')
if (has('nvim') || has('patch-7.4.1778')) && g:term_true_color
  " if has('nvim') | let $NVIM_TUI_ENABLE_TRUE_COLOR = 1 | endif
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

" Sessions {{{1

" Don't save all options and mappings
set sessionoptions-=options

if has('mksession')
  " set viewdir=$HOME/.vim/view " Customize location of saved views
  set viewoptions-=options " folds,options,cursor
  " cursor: cursor position in file and in window
  " folds: manually created folds, opened/closed folds and local fold options
  " options: options and mappings local to a window or buffer (not global values for local options)
  " localoptions: same as 'options'
  " slash,unix: useful on Windows when sharing view files
else
  " Restore cursor position when reading a file
  " https://github.com/farmergreg/vim-lastplace
  function! RestoreCursorPosition()
    if &filetype ==# 'gitcommit'
      return 0
    endif
    if line("'\"") > 0 && line("'\"") <= line('$')
      normal! g`"
      return 1
    endif
  endfunction
  augroup RestoreCursorPosition
    autocmd!
    autocmd BufReadPost * call RestoreCursorPosition()
  augroup END
endif

" Undodir {{{1

" Keep undo history across sessions
" expand(get(g:, 'undodir', '~/.vim/backups'))
if has('persistent_undo') " && exists('g:undodir')
  " Enable undo files
  set undofile
  let &undodir = mkdir#Var('undodir', $VIMHOME . '/backups')
  " Disable swapfiles and backups
  set noswapfile " directory=~/.vim/swap
  set nobackup " backupdir=~/.vim/backup
  set nowritebackup
endif

" Windows {{{1

if has('windows')
  set splitbelow " Split windows below the current window
  set splitright " Split windows right of the current window
  set winminheight=0 " Minimal height of a window when it's not the current one
  if &tabpagemax < 50
    set tabpagemax=50 " Maximum number of tab pages to be opened
  endif
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

" Diff mode {{{1

set diffopt+=vertical " Start diff mode with vertical splits

" See the difference between the current buffer and the file it was loaded from
if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" Columns {{{1

set number " Print the line number in front of each line
if has('linebreak') && exists('+numberwidth')
  " set numberwidth=4 " Minimal number of columns to use for the line number
endif
if exists('+relativenumber')
  set relativenumber " Show the line number relative to the line with the cursor
endif
if has('syntax') && exists('+colorcolumn')
  set colorcolumn=+1 " Color column relative to textwidth
endif

" Wrapping {{{1

set nowrap " Don't wrap lines by default
if has('linebreak')
  " Show line breaks (arrows: 0x21AA or 0x08627)
  "let &showbreak = nr2char(0x2026) " Ellipsis
  "set cpoptions+=n " Make 'showbreak' appear in between line numbers
endif

" Folding {{{1

if has('folding')
  set nofoldenable " All folds open, can be toggled with the zi command
  " set foldcolumn=1 " Width of the column which indicates open and closed folds
  " set foldlevelstart=10 " Sets 'foldlevel' when starting to edit another buffer
  set foldmethod=indent " Kind of folding used for the current window, see :h fdm
  " set foldminlines=0 " Number of screen lines above which a fold can be closed
  set foldnestmax=3 " Maximum nesting of folds for the 'indent' and 'syntax' methods
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

" Command line {{{1

if &history < 1000
  set history=1000 " Keep more lines of command line history
endif
set report=0 " Always report changed lines (default threshold: 2)
if has('cmdline_info')
  set showcmd " Display incomplete commands

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif
endif
" set showmode " Show current mode in command line
if has('wildmenu')
  " set wildchar=<Tab>
  set wildmenu " Display completion matches in a status line
  set wildmode=longest,full " Complete longest common string, then each full match
  " if exists('&wildignorecase') | set wildignorecase | endif
endif

" Complete {{{1

set complete-=i " Don't scan current and included files
set complete+=kspell " Use the currently active spell checking
if has('insert_expand')
  set completeopt+=longest " Only insert the longest common text of the matches
endif

" Searching {{{1

set gdefault " Reverse global flag (always apply to all, except if /g)
set ignorecase " Ignore case in search patterns
set magic " Changes the special characters that can be used in search patterns
set smartcase " Case sensitive when the search contains upper case characters
set wrapscan " Searches wrap around the end of the file

" Indenting {{{1

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

" Leader mappings {{{1

" Change leader
let g:mapleader = "\<Space>"

" set pastetoggle=<Leader>p

" Switch between the current and previous buffer :b#<CR>
nnoremap <Leader><Leader> <C-^>
" Add files to arglist with wildcards
nnoremap <Leader>a :argadd <C-r>=fnameescape(expand('%:p:h'))<CR>/*<C-D>
" Start the buffer prompt and display all loaded buffers
nnoremap <Leader>b :b **/*<C-D>
" Find a file in current working directory
nnoremap <Leader>e :e **/*
" Faster grep :noautocmd
nnoremap <Leader>g :grep<Space>
" Grep last search term similar files
" nnoremap <Leader>G :Grep <C-R>=(v:searchforward?@/:@?) *<C-R>=(expand('%:e')==''?'':'.'.expand('%:e'))
if exists(':Ilist') " Make :ilist go into a quickfix window
  nnoremap <Leader>i :Ilist<Space>
endif
" Taglist jump command line
nnoremap <Leader>j :tjump /
" Run make on the current buffer
nnoremap <Leader>m :make<CR>
" Quicker quit
nnoremap <Leader>q :q<CR>
" Remove trailing spaces in the current file
nnoremap <Leader>s :call StripTrailingWhitespace()<CR>
" Sort visually selected lines
vnoremap <Leader>s :sort<CR>
if exists(':TTags') " List and filter tags
  nnoremap <Leader>t :TTags<Space>*<Space>*<Space>.<CR>
endif
" Save a file
nnoremap <Leader>w :w<CR>
" Write as root
nnoremap <Leader>W :w!!<CR>

" Key bindings {{{1

" Use Q for formatting instead of switching to Ex mode
map Q gq

" Yank from the cursor to the end of the line like C, D...
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
" nnoremap <expr> 0 !&wrap ? '0' : 'g0'
" nnoremap <expr> $ !&wrap ? '$' : 'g$'

" Repeat latest linewise character searches (f, t, F or T [count] times)
noremap <Tab> ;

" Repeat last command on next match
noremap ; :normal n.<CR>

" Make 'dot' work as expected in visual mode
vnoremap . :norm.<CR>

" Repeat macro over all selected lines
" vnoremap @ :norm@

" Split navigation shortcuts
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

" Navigate tab pages
" nnoremap <Left> :tabprevious<CR>
" nnoremap <Right> :tabnext<CR>

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

" Stop the highlighting for the 'hlsearch' option and redraw the screen
nnoremap <silent> <Space> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
" if maparg('<C-L>', 'n') ==# ''
"   nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
" endif

" Edit in the same directory as the current file :e %%
cnoremap <expr> %% getcmdtype() ==# ':' ? fnameescape(expand('%:h')) . '/' : '%%'

" Use left and right arrow keys to move the cursor in command-line completion
" instead of selecting a different match, as Tab and S-Tab do
cnoremap <expr> <Left> getcmdtype() ==# ':' ? "\<Space>\<BS>\<Left>" : "\<Left>"
cnoremap <expr> <Right> getcmdtype() ==# ':' ? "\<Space>\<BS>\<Right>" : "\<Right>"

" Save current file as root with sudo
if maparg('w!!', 'c') ==# ''
  cnoremap w!! w !sudo tee % > /dev/null
endif

" Allow the use of 'dot' with 'k', e.g. indenting 3>k
" onoremap k 'V' . v:count1 . 'k' . v:operator

" Buffer operator (kana/vim-textobj-entire)
xnoremap i% GoggV
omap i% :<C-u>normal vi%<CR>

" Line operator (kana/vim-textobj-line)
xnoremap il g_o0
omap il :<C-u>normal vil<CR>
xnoremap al $o0
omap al :<C-u>normal val<CR>

" Indent the whole file
" noremap _= :call Preserve('normal gg=G')<CR>

" Make last typed word uppercase (inoremap <C-U> <Esc>viwUea)
" inoremap <Plug>UpCase <Esc>hgUawea
" imap ;u <Plug>UpCase

" Completion mappings
" inoremap <silent> ;f <C-x><C-f>
" inoremap <silent> ;i <C-x><C-i>
" inoremap <silent> ;l <C-x><C-l>
" inoremap <silent> ;n <C-x><C-n>
" inoremap <silent> ;o <C-x><C-o>
" inoremap <silent> ;p <C-x><C-p>
" inoremap <silent> ;t <C-x><C-]>

" Abbreviations {{{1

" Insert today's date
iabbrev <expr> ddate strftime('%b %d - %a')
" iabbrev <expr> dts strftime('%c')

" Commands {{{1

command! -nargs=+ Grep execute 'silent grep! <args>'

" command! -nargs=0 HexDump :%!xxd
" command! -nargs=0 HexRest :%!xxd -r

" Enable soft wrap (break lines without breaking words)
" command! -nargs=* Wrap setlocal wrap linebreak nolist

" Auto commands {{{1

augroup Config
  autocmd!
  " Reset colors persisting in terminal
  " autocmd VimLeave * :!echo -ne "\033[0m"
  " autocmd BufReadPost,FileReadPost *.py :silent %!PythonTidy.py
  " autocmd BufReadPost,FileReadPost *.p[lm] :silent %!perltidy -q
  " autocmd BufReadPost,FileReadPost *.xml :silent %!xmlpp -t -c -n
  " autocmd BufReadPost,FileReadPost *.[ch] :silent %!indent
  " autocmd BufEnter *.vim.local :setlocal filetype=vim

  if exists('+omnifunc')
    " Enable syntax completion when &omnifunc is empty
    autocmd Filetype * if &omnifunc ==# "" | setlocal omnifunc=syntaxcomplete#Complete | endif
  endif

  if has('nvim')
    " Fix Neovim Lazy Redraw: https://github.com/neovim/neovim/issues/4884
    " autocmd FocusLost * :set nolazyredraw
    " autocmd FocusGained * :redrawstatus
    " autocmd VimResized * :redrawstatus
  endif

  " Create missing intermediate directories before saving a file
  " BufNewFile,BufWritePre,FileWritePre pbrisbin/vim-mkdir
  autocmd BufWritePre * call mkdir#Ask()
augroup END

" 1}}}

call config#Source($HOME . '/.vimrc.local')

" vim: et sts=2 sw=2 ts=2 foldenable foldmethod=marker
