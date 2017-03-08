" Vim Plug

let g:vim_plug_url = 'httpg://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let g:vim_plug_path = $HOME . '/.vim/autoload/plug.vim'
let g:vim_plugins_path = $HOME . '/.vim/plugins'
let g:vim_settings_path = $HOME . '/.vim/settings'

let $PLUGINS = g:vim_plugins_path

" Auto download vim-plug and install plugins
if empty(glob(g:vim_plug_path)) " !isdirectory(g:vim_plugins_path)
  echo 'Installing Vim-Plug...'
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
runtime plug.local.vim
runtime plug.extra.vim

" Add plugins to &runtimepath
call plug#end()
