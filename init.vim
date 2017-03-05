" Vim

if &compatible
  set nocompatible
end

runtime before.vim

let s:vim_plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let s:vim_plug_path = $HOME . '/.vim/autoload/plug.vim'
let s:vim_plugins_path = $HOME . '/.vim/plugins'
let s:vim_settings_path = $HOME . '/.vim/settings'

" Auto download vim-plug and install plugins
if empty(glob(s:vim_plug_path)) " !isdirectory(s:vim_plugins_path)
  echo "Installing Vim-Plug..."
  execute 'silent !curl -fLo ' . s:vim_plug_path . '  --create-dirs ' . s:vim_plug_url
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Start Vim Plug
call plug#begin(s:vim_plugins_path)

" Register plugins
runtime addon.vim
runtime addon.local.vim
runtime addon.extra.vim

" Add plugins to &runtimepath
call plug#end()

" Load global options
source ~/.vim/config.vim

" Load plugin settings:
function! s:init()
  " Each file name in s:vim_settings_path must be an exact substring of the
  " plugin directory under s:vim_plugins_path to be sourced
  for s:path in split(globpath(s:vim_settings_path, '*.vim'), '\n')
    let s:name = fnamemodify(s:path, ':t:r')
    if !empty(globpath(s:vim_plugins_path, '*' . s:name . '*'))
      execute 'source ' . s:path
    endif
  endfor
endfunction

if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif

augroup VimInit
  autocmd!
  autocmd VimEnter * call s:init()
augroup END
