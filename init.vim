" Vim

function! Exists(path)
  return filereadable(expand(a:path))
endfunction

runtime before.vim

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

" Load plugin settings
let s:settings_path = '~/.vim/settings'
let s:plugins_path = '~/.vim/plugged'
" Each file name in s:settings_path must be an exact substring of the
" plugin directory under s:plugins_path to be sourced
for s:path in split(globpath(s:settings_path, '*.vim'), '\n')
  let s:name = fnamemodify(s:path, ':t:r')
  if !empty(globpath(s:plugins_path, '*' . s:name . '*'))
    execute 'source ' . s:path
  endif
endfor

runtime config.vim

if Exists('~/.vimrc.local')
  source ~/.vimrc.local
endif
