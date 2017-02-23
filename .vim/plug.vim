" Plugins

let g:vim_plugins = expand('~/.vim/plugged')
call plug#begin(g:vim_plugins)

Plug 'altercation/vim-colors-solarized'
" Plug 'AndrewRadev/splitjoin.vim' " Line/multiline transitions
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy finder
" Plug 'editorconfig/editorconfig-vim'
Plug 'sheerun/vim-polyglot' " Syntax and indentation language pack
" Plug 'tpope/vim-abolish' " Search, substitute and abbreviate variants
Plug 'tpope/vim-commentary' " Comment stuff out
" Plug 'tpope/vim-endwise' " Automatic end keywords
" Plug 'tpope/vim-eunuch' " Helpers for UNIX shell commands
" Plug 'tpope/vim-fugitive' " Git wrapper
" Plug 'shumphrey/fugitive-gitlab.vim'
" Plug 'tpope/vim-obsession' " Continuously updated session files
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps
Plug 'tpope/vim-sensible' " Sane defaults
Plug 'tpope/vim-sleuth' " Automatic indentation detection
Plug 'tpope/vim-surround' " Quoting/parenthesizing
Plug 'tpope/vim-unimpaired' " Mappings
Plug 'tpope/vim-vinegar' " Improved netrw directory browser

" Completion: Valloric/YouCompleteMe + SirVer/ultisnips
" Syntax Checker: scrooloose/syntastic
" Text Objects: kana/vim-textobj-user

" Add plugins to &runtimepath
call plug#end()

try
  set background=dark
  colorscheme solarized
  call togglebg#map('<F5>')
catch /E185:/
  colorscheme default
endtry
