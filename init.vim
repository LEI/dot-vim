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

function! s:path(path)
  return expand(g:vim_dir . '/' . a:path)
endfunction

function! Source(path)
  if filereadable(expand(a:path))
    execute 'source' a:path
  endif
endfunction

function! SourceIf(path, func)
  if !exists('*' . a:func)
    echoerr 'Unknown function:' a:func
    return 0
  endif
  if {a:func}(a:path)
    call Source(a:path)
  endif
endfunction

function! IsEnabled(path)
  let l:name = fnamemodify(a:path, ':t:r')
  " Enable Package: let g:enable_{l:name} = 1
  " !exists('g:enable_' . l:name) || g:enable_{l:name} == 0
  let l:enabled = get(g:, 'enable_' . l:name, 0) == 1
  for l:pattern in get(g:, 'plugins_whitelist', [])
    if matchstr(l:name, l:pattern)
      let l:enabled = 1
      break
    endif
  endfor
  " echom l:name . ' is ' . (l:enabled ? 'enabled' : 'disabled')
  return l:enabled
endfunction

function! SourceDir(path)
  " let l:func = a:0 > 1 ? a:2 : 'Source'
  let l:files = globpath(a:path, '*.vim')
  for l:path in split(l:files, '\n')
    call Source(l:path)
  endfor
endfunction

function! SourceDirIf(path, func)
  let l:files = globpath(a:path, '*.vim')
  for l:path in split(l:files, '\n')
    call SourceIf(l:path, a:func)
  endfor
endfunction

function! SourceEnabledDir(path)
  return SourceDirIf(a:path, 'IsEnabled')
endfunction

function! PlugDownload(...)
  let l:path = a:0 ? a:1 : g:plug_path
  if !empty(glob(l:path))
    return 0 " Already exists
  endif
  " confirm('Download vim-plug in ' . l:path . '?') == 1
  execute 'silent !curl -fLo' l:path '--create-dirs' g:plug_url
  " return code?
endfunction

" Variables {{{1
"
let g:utf8 = has('multi_byte') && &encoding ==# 'utf-8'

let g:vim_dir = split(&runtimepath, ',')[0] " $HOME . '/.vim'
let g:vim_undodir = get(g:, 'vim_undodir', s:path('backups'))

let g:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let g:plug_path = s:path('autoload/plug.vim')
" let g:plug_home = s:path('plugged')

" Plugins {{{1

" Automatically install vim-plug
let s:plug_install = PlugDownload()

" Start Vim Plug
call plug#begin()

" let g:plugins_whitelist = ['plugins']

let g:enable_plugins = 1
let g:enable_solarized = 1

" Improvements:
let g:enable_commentary = 1
let g:enable_fugitive = 1
let g:enable_splitjoin = 1
let g:enable_tabular = 0
let g:enable_unimpaired = 1
let g:enable_textobjuser = 1

" Search:
let g:enable_ctrlp = 1
let g:ctrlp_status_func = {'main': 'status#ctrlp#Main', 'prog': 'status#ctrlp#Prog'}

" Languages:
let g:enable_polyglot = 1
let g:enable_tern = executable('node') && executable('npm')

" Formatting: google/vim-codefmt
" let g:enable_editorconfig = 1 " Breaks &et

" Syntax Checkers: scrooloose/syntastic, maralla/validator.vim
let g:enable_neomake = 0 " has('nvim') || v:version > 704 || v:version == 704 && has('patch503')
let g:enable_ale = has('nvim') || v:version >= 800
" let g:ale_filetype_blacklist = ['nerdtree', 'unite', 'tags']

" Auto Completion: ervandew/supertab, vim-scripts/AutoComplPop
let g:enable_youcompleteme = 0 " has('python') || has('python3')
let g:enable_ultisnips = g:enable_youcompleteme
let g:enable_deoplete = has('nvim') && has('python3')
let g:enable_neocomplete = !has('nvim') && has('lua')
let g:enable_neosnippet = g:enable_deoplete || g:enable_neocomplete

" runtime packages.vim

" Register plugins
call SourceEnabledDir(s:path('plugins'))

" Add plugins to &runtimepath
call plug#end()

if s:plug_install == 1
  PlugInstall --sync | source $MYVIMRC
endif

" Register plugins
call SourceDir(s:path('config'))

" command! -nargs=0 -bar Install PlugInstall --sync | source $MYVIMRC
" command! -nargs=0 -bar Update PlugUpdate --sync | source $MYVIMRC
" command! -nargs=0 -bar Upgrade PlugUpdate! --sync | PlugUpgrade | source $MYVIMRC

" Load matchit.vim
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &runtimepath) ==# ''
  runtime! macros/matchit.vim
endif

" General options {{{1

" has('autocmd')
filetype plugin indent on

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

set synmaxcol=420 " Limit syntax highlighting for long lines

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

" Views {{{1

" Options:
" cursor: cursor position in file and in window
" folds: manually created folds, opened/closed folds and local fold options
" options: options and mappings local to a window or buffer (not global values for local options)
" localoptions: same as 'options'
" slash,unix: useful on Windows when sharing view files

" set viewdir=$HOME/.vim/view " Customize location of saved views
set viewoptions-=options " folds,options,cursor

" Return true if the current buffer state should be saved or restored
function! s:is_file() abort
  " vim-vinegar opendir() error on Enter (-) if &modifiable is off
  if &buftype !=# '' || &filetype ==# ''
    return 0
  endif
  if &filetype =~# 'help\|netrw\|qf' " &filetype !=# ''
    return 0
  endif
  return 1
endfunction

augroup ViewGroup
  autocmd!
  autocmd VimEnter,BufWinEnter * if s:is_file() | silent! loadview | endif
  autocmd BufWinLeave * if s:is_file() | mkview | endif
augroup END

" Undo history {{{1

" Keep undo history across sessions
" expand(get(g:, 'vim_undodir', '~/.vim/backups'))
if has('persistent_undo') " && exists('g:vim_undodir')
  " Disable swapfiles and backups
  set noswapfile
  set nobackup
  set nowritebackup
  if exists('*mkdir') && !isdirectory(g:vim_undodir)
    call mkdir(g:vim_undodir)
  endif
  let &undodir = g:vim_undodir
  set undofile
endif

" Characters {{{1

" Default: set fillchars=stl:^,stlnc:=,vert:\|,fold:-,diff:-
" let &fillchars='stl: ,stlnc: '

set list " Show invisible characters
" let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+ " ,eol:$
if g:utf8 == 1
  let &listchars = 'tab:' . nr2char(0x25B8) . ' '
        \ . ',trail:' . nr2char(0x00B7)
        \ . ',extends:' . nr2char(0x276F)
        \ . ',precedes:' . nr2char(0x276E)
        \ . ',nbsp:' . nr2char(0x005F)
        \ . ',eol:' . nr2char(0x00AC)
endif

" " let &showbreak = '-> '
" if g:utf8
"   " Show line breaks (arrows: 0x21AA or 0x08627)
"   let &showbreak = nr2char(0x2026) " Ellipsis
" endif

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
function! <SID>HighlightCursor() abort
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
set incsearch " Show the pattern matches while typing
" set magic " Changes the special characters that can be used in search patterns
set smartcase " Case sensitive when the search contains upper case characters

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

set scrolloff=3 " Lines to keep above and below the cursor
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

" Splits {{{1

set splitbelow " Split windows below the current window
set splitright " Split windows right of the current window
set diffopt+=vertical " Always use vertical diffs

" Command line {{{1

set showcmd " Display incomplete commands
set noshowmode " Hide current mode in command line
set wildmenu " Invoke completion on <Tab> in command line mode
set wildmode=longest,full " Complete longest common string, then each full match

" Status line {{{1

set display+=lastline " Display as much as possible of the last line
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

function! <SID>HighlightStatusLine() abort
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

" Yank from the cursor to the end of the line
noremap Y y$

" Visually select the text that was last edited/pasted
noremap gV `[v`]

" Move on wrapped lines unless a count is specified
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
" nnoremap 0 g0
" nnoremap $ g$ " FIXME :set wrap

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

" Repeat latest f, t, F or T [count] times
noremap <Tab> ;

" Repeat last command on next match
noremap ; :normal n.<CR>

" Make 'dot' work as expected in visual mode
" vnoremap . :norm.<CR>

" Paragraph reflow according to textwidth?
" vnoremap Q gv
" noremap Q gqap

" if maparg('<C-l>', 'n') ==# ''
"   nnoremap <silent> <C-l> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-l>
" endif

" Stop the highlighting for the 'hlsearch' option
nnoremap <silent> <Space> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-l>

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

" http://vimcasts.org/episodes/tidying-whitespace/
" https://github.com/bronson/vim-trailing-whitespace
" https://github.com/csexton/trailertrash.vim
function! <SID>StripTrailingWhitespaces()
  call <SID>Preserve("%s/\\s\\+$//e")
endfunction

" Error detected while processing BufWritePre Auto commands for "*.js":
" E488: Trailing characters
function! <SID>Preserve(command)
  " Save last search and cursor position
  let l:_s=@/
  let l:l = line('.')
  let l:c = col('.')
  " let save_cursor = getpos(".")
  " let old_query = getreg('/')
  " Do the business
  execute a:command
  " Clean up: restore previous search history and cursor position
  let @/=l:_s
  call cursor(l:l, l:c)
  " call setpos('.', save_cursor)
  " call setreg('/', old_query)
endfunction

" Remove trailing spaces
noremap _$ :call <SID>StripTrailingWhitespaces()<CR>

" Indent the whole file
noremap _= :call <SID>Preserve("normal gg=G")<CR>

" Leader mappings {{{1

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

" Enable soft wrap (break lines without breaking words)
" command! -nargs=* Wrap setlocal wrap linebreak nolist
" command! -nargs=* CursorHi call <SID>HighlightCursor()

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
  autocmd VimEnter,ColorScheme * :call <SID>HighlightCursor() | :call <SID>HighlightStatusLine()

  " Fix Neovim Lazy Redraw: https://github.com/neovim/neovim/issues/4884
  " autocmd FocusLost * :set nolazyredraw
  autocmd FocusGained * :redrawstatus
  " autocmd VimResized * :redrawstatus

  " autocmd BufReadPost,FileReadPost *.py :silent %!PythonTidy.py
  " autocmd BufReadPost,FileReadPost *.p[lm] :silent %!perltidy -q
  " autocmd BufReadPost,FileReadPost *.xml :silent %!xmlpp -t -c -n
  " autocmd BufReadPost,FileReadPost *.[ch] :silent %!indent

  autocmd BufWritePre *.js,*.php,*.py :call <SID>StripTrailingWhitespaces()

  " Commentary
  autocmd FileType cfg,inidos setlocal commentstring=#\ %s
  autocmd FileType xdefaults setlocal commentstring=!\ %s

  " Auto reload vimrc on save
  autocmd BufWritePost $MYVIMRC nested source %
  " autocmd BufEnter *.vim.local :setlocal filetype=vim
augroup END

" }}}

call Source('~/.vimrc.local')
" if filereadable($HOME . '/.vimrc.local')
"   source ~/.vimrc.local
" endif

" vim: et sts=2 sw=2 ts=2 foldenable foldmethod=marker
