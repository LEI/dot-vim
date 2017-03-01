" Vim

if &compatible
  set nocompatible
end

runtime before.vim

let s:vim_plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let s:vim_plug_path = $HOME . '/.vim/autoload/plug.vim'
let s:vim_plugins_path = $HOME . '/.vim/plugins'
let s:vim_settings_path = $HOME . '/.vim/settings'

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
source config.vim

" Load plugin settings:
" Each file name in s:vim_settings_path must be an exact substring of the
" plugin directory under s:vim_plugins_path to be sourced
for s:path in split(globpath(s:vim_settings_path, '*.vim'), '\n')
  let s:name = fnamemodify(s:path, ':t:r')
  if !empty(globpath(s:vim_plugins_path, '*' . s:name . '*'))
    execute 'source ' . s:path
  endif
endfor

runtime vimrc.local
