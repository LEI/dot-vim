" Vim Plug

Plug 'romainl/flattened' " altercation/vim-colors-solarized
" Plug 'AndrewRadev/splitjoin.vim' " Line/multiline transitions
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy finder
" Plug 'editorconfig/editorconfig-vim'
Plug 'mbbill/undotree' " Undo history visualizer
Plug 'sheerun/vim-polyglot' " Syntax and indentation language pack
" Plug 'tpope/vim-abolish' " Search, substitute and abbreviate variants
Plug 'tpope/vim-commentary' " Comment stuff out
" Plug 'tpope/vim-endwise' " Automatic end keywords
" Plug 'tpope/vim-eunuch' " Helpers for UNIX shell commands
" Plug 'tpope/vim-fugitive' " Git wrapper
" Plug 'shumphrey/fugitive-gitlab.vim' " Add Gitlab support
" Plug 'tpope/vim-obsession' " Continuously updated session files
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps
Plug 'tpope/vim-sensible' " Sane defaults
Plug 'tpope/vim-sleuth' " Automatic indentation detection
Plug 'tpope/vim-surround' " Quoting/parenthesizing
Plug 'tpope/vim-unimpaired' " Mappings
Plug 'tpope/vim-vinegar' " Improved netrw directory browser

" Text Objects: kana/vim-textobj-user

function! YCMInstall(info)
  " The variable a:info is a dictionary with 3 fields:
  " - name: name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force: set on PlugInstall! or PlugUpdate!
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

" Plug 'Valloric/YouCompleteMe', {'do': function('YCMInstall'), 'on': []} " Code completion
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' " Code snippets
" " command! YCM call YCMEnable()
" " autocmd! User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif
" function! YCMEnable()
"   if !exists('g:loaded_youcompleteme')
"     call plug#load('YouCompleteMe')
"   else
"     echom "YCM is already loaded"
"   endif
"   if exists('g:loaded_youcompleteme')
"     call youcompleteme#Enable()
"   else
"     echom "YCM was not loaded"
"   endif
" endfunction

" Plug 'scrooloose/syntastic', {'on': []} " Syntax checker
" function! SyntasticEnable()
"   if !exists('g:loaded_syntastic_plugin')
"     call plug#load('syntastic')
"   endif
" endfunction

function! s:VimPlug()
  if &filetype == 'gitcommit'
    return
  endif
  " call YCMEnable()
  " call SyntasticEnable()
endfunction

augroup VimPlug
  autocmd!
  autocmd VimEnter * redrawstatus | call s:VimPlug() | autocmd! VimPlug
augroup END
