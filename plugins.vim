" Vim Plug

Plug 'altercation/vim-colors-solarized' " (alt: romainl/flattened)
" Plug 'AndrewRadev/splitjoin.vim' " Line/multiline transitions
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy finder (alt: junegunn/fzf.vim)
" Plug 'editorconfig/editorconfig-vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'} " Undo history visualizer
Plug 'sheerun/vim-polyglot' " Syntax and indentation language pack
" Plug 'tpope/vim-abolish' " Search, substitute and abbreviate variants
Plug 'tpope/vim-commentary' " Comment stuff out
Plug 'tpope/vim-endwise' " Automatic end keywords
" Plug 'tpope/vim-eunuch' " Helpers for UNIX shell commands
" Plug 'tpope/vim-fugitive' " Git wrapper
" Plug 'shumphrey/fugitive-gitlab.vim' " Add Gitlab support
" Plug 'tpope/vim-obsession' " Continuously updated session files
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps
Plug 'tpope/vim-sensible' " Sane defaults
Plug 'tpope/vim-sleuth' " Automatic indentation detection (alt: ciaranm/detectindent)
Plug 'tpope/vim-surround' " Quoting/parenthesizing
Plug 'tpope/vim-unimpaired' " Mappings
Plug 'tpope/vim-vinegar' " Improved netrw directory browser (alt: justinmk/vim-dirvish)

" Text Objects: kana/vim-textobj-user

" Syntax checkers: scrooloose/syntastic, maralla/validator.vim, w0rp/ale
" vim >= 7.4.503, nvim >= 0.0.0-alpha+201503292107
Plug 'neomake/neomake', has('nvim') ? {} : {'on': 'Neomake'}

" Code completion and snippets:
if has('lua')
  Plug 'Shougo/neocomplete.vim' ", {'on': 'NeoCompleteEnable'}
  Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'
endif

" Plug 'Valloric/YouCompleteMe', {'do': function('YCMInstall'), 'on': []}
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" The variable a:info is a dictionary with 3 fields:
" - name: name of the plugin
" - status: 'installed', 'updated', or 'unchanged'
" - force: set on PlugInstall! or PlugUpdate!
function! YCMInstall(info)
  if a:info.status == 'installed' || a:info.force
    " The following additional language support options are available
    " - C# support: add --omnisharp-completer to ./install.py
    " - Go support: ensure go is installed and add --gocode-completer
    " - TypeScript support: install nodejs and npm then install the TypeScript SDK with npm install -g typescript.
    " - JavaScript support: install nodejs and npm and add --tern-completer when calling ./install.py
    " - Rust support: install rustc and cargo and add --racer-completer when calling ./install.py
    !./install.py --tern-completer --gocode-completer
  endif
endfunction

" autocmd! User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif

" !exists('g:loaded_youcompleteme')
" :call plug#load('YouCompleteMe')
" :call youcompleteme#Enable()
