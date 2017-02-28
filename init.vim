" Vim

function! Exists(path)
  return filereadable(expand(a:path))
endfunction

runtime before.vim

runtime config.vim

let g:vim_plugins_path = '~/.vim/plugged'
let g:vim_plug_path = '~/.vim/autoload/plug.vim'
let g:vim_plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

" Auto download vim-plug
if !Exists(g:vim_plug_path)
  execute 'silent !curl -sfLo ' . g:vim_plug_path . '  --create-dirs ' . g:vim_plug_url
endif

let g:vim_plugins = expand(g:vim_plugins_path)
call plug#begin(g:vim_plugins)

runtime plug.vim

" Add plugins to &runtimepath
call plug#end()

" Install plugins
if !isdirectory(g:vim_plugins)
  PlugInstall
endif

if Exists('~/.vimrc.local')
  source ~/.vimrc.local
endif
