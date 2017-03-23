" Initialize configuration

if exists('g:loaded_config')
  finish
endif

let g:loaded_config = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" let g:config_path = get(g:, 'config_path', $VIMHOME . '/config')
if !exists('$VIMHOME')
  let $VIMHOME = expand('$VIMHOME')
endif
if empty($VIMHOME)
  let $VIMHOME = expand('~/.vim')
endif
if !exists('$VIMCONFIG') || empty($VIMCONFIG)
  let $VIMCONFIG = $VIMHOME . '/config'
endif

command! -nargs=0 -bar Install PlugInstall
command! -nargs=0 -bar -bang Install PlugInstall<bang>
command! -nargs=0 -bar Update PlugUpdate
command! -nargs=0 -bar -bang Update PlugUpdate<bang>
command! -nargs=0 -bar Upgrade PlugUpgrade | PlugUpdate!

command! -nargs=* -bar -complete=customlist,s:ListEnabled Reload call config#LoadConfig(<f-args>)
command! -nargs=* -bar -complete=customlist,s:ListDisabled Enable call config#LoadConfig(<f-args>)
" command! -nargs=? -bar LoadEnabled call config#LoadEnabled(<f-args>)

" Automatically install Vim Plug and configure enabled plugins
function! config#Init(...) abort
  let l:dir = a:0 ? a:1 : $VIMCONFIG
  " let g:plug_home = a:root . '/plugged'
  let g:plug_path = $VIMHOME . '/autoload/plug.vim'
  let g:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  if empty(glob(g:plug_path))
    execute 'silent !curl -sfLo ' . g:plug_path . ' --create-dirs ' . g:plug_url
    let g:plug_install = 1
  endif
  call config#LoadEnabled(l:dir)
endfunction

" Load a list of paths
function! config#Load(...) abort
  let l:files = a:000
  call plug#begin()
  for l:path in l:files
    call config#Source(l:path)
  endfor
  call plug#end()
  call config#Enable()
endfunction

" Source $VIMCONFIG/{name}.vim
function! config#LoadConfig(...) abort
  let l:files = deepcopy(a:000)
  call map(l:files, "printf('%s/%s.vim', $VIMCONFIG, v:val)")
  return config#Load(l:files)
endfunction

" Source $VIMHOME/{$dir,$dir/init,$dir/*}.vim
function! config#LoadEnabled(dir) abort
  call plug#begin() " Start Vim Plug
  call config#Source(a:dir . '.vim')
  if isdirectory(a:dir)
    call config#Source(a:dir . '/init.vim')
    call config#SourceDir(a:dir, 'config#IsEnabled')
  endif
  call plug#end() " Add plugins to &runtimepath
  augroup InitConfig
    autocmd!
    " Wait until vim is ready to clone and configure or :PlugInstall will create the first window
    autocmd VimEnter * if get(g:, 'plug_install', 0) | PlugInstall --sync | let g:plug_install = 0 | endif
        \ | call config#Enable()
        \ | :autocmd! InitConfig
  augroup END
endfunction

function! config#Enable() abort
  if !exists('#User#Config')
    return 0
  endif
  augroup UserConfig
    autocmd!
    " Clear User Config autocommands after executing it
    autocmd User Config :autocmd! User Config
  augroup END
  doautocmd User Config
endfunction

" Check g:enable_{name}
function! config#IsEnabled(path) abort
  let l:name = fnamemodify(a:path, ':t:r')
  " !exists('g:enable_' . l:name) || g:enable_{l:name} == 0
  let l:enabled = get(g:, 'enable_' . l:name, 0) == 1
  " for l:pattern in get(g:, 'plugins_enable', [])
  "   if matchstr(l:name, l:pattern)
  "     let l:enabled = 1
  "     break
  "   endif
  " endfor
  " echom l:name . ' is ' . (l:enabled ? 'enabled' : 'disabled')
  return l:enabled
endfunction

function! config#Source(...) abort
  let l:path = a:0 > 0 ? a:1 : ''
  let l:func = a:0 > 1 ? a:2 : ''
  if strlen(l:path) == 0
    echoerr 'Invalid argument: missing file path'
    return 0
  endif
  if strlen(l:func) > 0
    if !exists('*' . l:func)
      echoerr 'Unknown function:' l:func
      return 0
    endif
    if {l:func}(l:path) " call(l:Func, [l:path])
      return s:source(l:path)
    endif
    return 0
  endif
  return s:source(l:path)
endfunction

function! config#SourceDir(...) abort
  let l:dir = a:1
  let l:func = a:0 > 1 ? a:2 : ''
  let l:pattern = a:0 > 2 ? a:3 : '*.vim'
  if strlen(l:dir) == 0
    echoerr 'Invalid argument: missing directory path'
    return 0
  endif
  if !isdirectory(l:dir)
    echoerr 'Invalid directory:' l:dir
    return 0
  endif
  let l:files = globpath(expand(l:dir), l:pattern)
  for l:path in split(l:files, '\n')
    if strlen(l:func) > 0
      call config#Source(l:path, l:func)
    else
      call config#Source(l:path)
    endif
  endfor
endfunction

function! s:source(path) abort
  if !filereadable(expand(a:path))
    return 0
  endif
  execute 'source' a:path
endfunction

function! s:List(ArgLead, CmdLine, CursorPos) abort
  let l:list = split(globpath($VIMCONFIG, a:ArgLead . '*.vim'), "\n")
  " call map(l:list, string(a:fn) . '(v:val)')
  call map(l:list, "fnamemodify(v:val, ':t:r')")
  return l:list
endfunction

function! s:ListEnabled(ArgLead, CmdLine, CursorPos) abort
  let l:list = split(globpath($VIMCONFIG, a:ArgLead . '*.vim'), "\n")
  return s:FilterList(l:list, "get(g:, 'enable_' . v:val, 0) == 1")
endfunction

function! s:ListDisabled(ArgLead, CmdLine, CursorPos) abort
  let l:list = split(globpath($VIMCONFIG, a:ArgLead . '*.vim'), "\n")
  call filter(l:list, "v:val !=# $VIMCONFIG . '/init.vim'")
  return s:FilterList(l:list, "get(g:, 'enable_' . v:val, 0) == 0")
endfunction

function! s:FilterList(list, filter) abort
  let l:list = deepcopy(a:list)
  call map(l:list, "fnamemodify(v:val, ':t:r')")
  call filter(l:list, a:filter)
  return l:list
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
