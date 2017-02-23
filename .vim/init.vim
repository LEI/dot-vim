" Vim

function! Exists(path)
  return filereadable(expand(a:path))
endfunction

if Exists('~/.vim/before.vim')
  source ~/.vim/before.vim
endif

if Exists('~/.vim/config.vim')
  source ~/.vim/config.vim
endif

" Auto download Vim Plug
let g:vim_plug_path = '~/.vim/autoload/plug.vim'
let g:vim_plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if !Exists(g:vim_plug_path)
  execute 'silent !curl -sfLo ' . g:vim_plug_path . '  --create-dirs ' . g:vim_plug_url
endif

if Exists('~/.vim/plug.vim')
  source ~/.vim/plug.vim
endif

" Install plugins
if !isdirectory(g:vim_plugins)
  PlugInstall
endif

if Exists('~/.vimrc.local')
  source ~/.vimrc.local
endif
