" Vim

function! Exists(path)
  return filereadable(expand(a:path))
endfunction

if Exists('~/.vim/before.vim')
  source ~/.vim/before.vim
endif

" Auto download Vim Plug
let g:vim_plug_path = '~/.vim/autoload/plug.vim'
let g:vim_plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if !Exists(g:vim_plug_path)
  execute 'silent !curl -sfLo ' . g:vim_plug_path . '  --create-dirs ' . g:vim_plug_url
endif

let g:vim_plugins = expand('~/.vim/plugged')
call plug#begin(g:vim_plugins)

Plug 'altercation/vim-colors-solarized'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'

" Add plugins to &runtimepath
call plug#end()

" Install plugins
if !isdirectory(g:vim_plugins)
  PlugInstall
endif

try
  set background=dark
  colorscheme solarized
  call togglebg#map('<F5>')
catch /E185:/
  colorscheme default
endtry

if Exists('~/.vimrc.local')
  source ~/.vimrc.local
endif
