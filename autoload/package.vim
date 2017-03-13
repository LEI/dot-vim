" Package

" set statusline=%!statusline#Build()

if exists('g:loaded_package')
  finish
endif

let g:loaded_package = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:packages = []
let s:vim_dir = $HOME . '/.vim'

let g:package#plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let g:package#plug_path = s:vim_dir . '/autoload/plug.vim' " Vim Plug
let g:package#plugins_dir = s:vim_dir . '/plugins' " Plugin directory
let g:package#dir = s:vim_dir . '/packages' " Plugin configuration

function! package#Begin(...) abort
  let l:path = a:0 ? a:1 : g:package#plugins_dir
  " Make sur Vim Plug is present
  call package#Install(g:package#plug_path)
  " Start plugin declarations
  call plug#begin(l:path)
endfunction

" Auto download vim-plug and install plugins
function! package#Install(path) abort
  if !empty(glob(a:path))
    " isdirectory(g:vim_plugins_path)
    let g:package#did_install = 0
    return 0 " Already exists
  endif
  " echo 'Installing Vim-Plug...'
  execute 'silent !curl -fLo ' . a:path . '  --create-dirs ' . g:package#plug_url
  let g:package#did_install = 1
  return 1 " TODO: check curl exit code
endfunction

function! package#Plug(...) abort
  " Load configuration file: ~/.vim/packages.vim
  runtime packages.vim
  let l:dir = a:0 ? a:1 : g:package#dir
  for l:path in split(globpath(l:dir, '*.vim'), '\n')
    let l:name = fnamemodify(l:path, ':t:r')
    " To enable a package file, :let g:package#{l:name}_enabled = 1
    " if exists('g:package#' . l:name . '_enabled') && g:package#{l:name}_enabled == 1
    if get(g:, 'package#' . l:name . '_enabled', 0) != 1
      continue
    endif
    " let l:pkg = {'name': l:name, 'path': l:path}
    " Source configuration file
    execute 'source ' . l:path
  endfor
endfunction

function! package#Add(pkg) abort
  if !has_key(a:pkg, 'name')
    echoerr 'Package should have a name'
    return 1
  endif
  for l:pkg in s:packages
    if l:pkg.name == a:pkg.name
      " echoerr 'Package already exists with that name: ' . l:pkg.name
      let l:pkg = a:pkg
      return 1
    endif
  endfor
  call add(s:packages, a:pkg)
endfunction

function! package#End() abort
  call plug#end()
  for s:pkg in s:packages
    if has_key(s:pkg, 'on')
      if has_key(s:pkg.on, 'plug_end') " exists('*s:pkg.on.plug_end')
        call s:pkg.on.plug_end()
      endif
    endif
  endfor
  if g:package#did_install
    augroup PlugInstall
      autocmd!
      autocmd VimEnter * PlugInstall --sync
      " | source $MYVIMRC
    augroup END
  endif
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

