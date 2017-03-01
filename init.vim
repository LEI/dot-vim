" Vim

runtime before.vim

let s:vim_plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let s:vim_plug_path = $HOME . '/.vim/autoload/plug.vim'
let s:vim_plugins_path = $HOME . '/.vim/plugins'

" Auto download vim-plug
if !filereadable(s:vim_plug_path)
  execute 'silent !curl -sfLo ' . s:vim_plug_path . '  --create-dirs ' . s:vim_plug_url
endif

" Start Vim Plug
call plug#begin(s:vim_plugins_path)

" Register plugins
runtime plugins.vim

runtime plugins.local.vim

" Add plugins to &runtimepath
call plug#end()

" Install plugins on first run
if !isdirectory(s:vim_plugins_path)
  PlugInstall
endif

" Load global options
runtime config.vim

runtime settings

runtime vimrc.local
