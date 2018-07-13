" Initialize configuration

if exists('g:loaded_config')
  finish
endif

let g:loaded_config = 1

let g:use_minpac = v:version >= 800

let s:save_cpo = &cpoptions
set cpoptions&vim

if !exists('$VIMHOME')
  let $VIMHOME = expand('$VIMHOME')
endif

if empty($VIMHOME)
  let $VIMHOME = expand('~/.vim')
endif

if !exists('$VIMCONFIG') || empty($VIMCONFIG)
  let $VIMCONFIG = $VIMHOME . '/config'
endif

let g:pack_dir = 'config'
let g:pack_path = get(g:, 'minpac_path', $VIMHOME . '/pack/' . g:pack_dir)
let g:minpac_opts = {'package_name': g:pack_dir}
" 'dir' Base directory. Default: the first directory of the 'packpath' option.
" 'package_name' Package name. Default: 'minpac'
" 'git' Git command. Default: 'git'
" 'depth' Default clone depth. Default: 1
" 'jobs' Maximum job numbers. If <= 0, unlimited. Default: 8
" 'verbose' Verbosity level (0 to 3). Default: 1

let g:minpac_path = get(g:, 'minpac_path', g:pack_path . '/opt/minpac')
let g:minpac_url = get(g:, 'minpac_url', 'https://github.com/k-takata/minpac.git')

let g:plug_path = get(g:, 'plug_path', $VIMHOME . '/autoload/plug.vim')
let g:plug_url = get(g:, 'plug_url', 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
" let g:plug_pac = get(g:, 'plug_home', $VIMHOME . '/pack/plug/opt/autoload/plug.vim')
let g:plug_home = get(g:, 'plug_home', g:pack_path . '/opt')

let g:config_expr_name = "fnamemodify(v:val, ':t:r')"
let g:config_expr_enabled = "get(g:, 'enable_' . fnamemodify(v:val, ':t:r'), 0) == 1"

function! config#Start(...) abort
  if exists('v:vim_did_enter') && v:vim_did_enter
    echom 'Vim already started!'
    return
  endif
  call config#Init() " Initialize User Config
  if g:use_minpac
    if !isdirectory(g:minpac_path)
      call s:Clone(g:minpac_url, g:minpac_path)
      let s:do_install = 1
    endif
    packadd minpac
    " silent! exists('*minpac#init')
    call minpac#init(g:minpac_opts)
    call config#LoadDir()
    if get(s:, 'do_install', 0) == 1
      " silent?
      call minpac#update()
    endif
    " Load optional plugins (packloadall)
    for l:name in minpac#getpackages('', 'opt', '', 1)
      execute 'packadd' l:name
    endfor
  else
    if empty(glob(g:plug_path))
      execute 'silent !curl -sfLo ' . g:plug_path . ' --create-dirs ' . g:plug_url
      let s:do_install = 1
    endif
    call plug#begin() " Start Vim Plug
    call config#LoadDir() " Source plugins configuration ($VIMHOME . '/config')
    call plug#end() " Add plugins to &runtimepath
  endif
endfunction

" Automatically install Vim Plug and configure enabled plugins
function! config#Init(...) abort
  augroup UserConfig
    autocmd!
    autocmd VimEnter * call s:Init()
    " FIXME: User Config autocommands not cleared with 'autocmd! User Config'
    autocmd VimEnter * autocmd! UserConfig
    autocmd VimEnter * augroup! UserConfig
  augroup END
endfunction

" :packadd or :Load()
function! config#(...) abort
  return call(function('s:Pack'), a:000)
endfunction

" Source $VIMHOME/{$dir,$dir/init,$dir/*}.vim
function! config#LoadDir(...) abort
  let l:dir = a:0 ? a:1 : $VIMCONFIG
  call s:Source(l:dir . '.vim')
  if isdirectory(l:dir)
    let l:list = s:GlobPath(l:dir)
    call s:Source(l:dir . '/init.vim')
    call s:SourceDir(l:dir, g:config_expr_enabled)
  endif
endfunction

" Source $VIMCONFIG/{name}.vim
function! config#Load(...) abort
  return call(function('s:Load'), a:000)
endfunction

function! config#UserConfig(...) abort
  return call(function('s:DoAutoCmd'), a:000)
endfunction

function! config#Source(...) abort
  return call(function('s:Source'), a:000)
endfunction

function! config#SourceDir(...) abort
  return call(function('s:SourceDir'), a:000)
endfunction

function! s:Init() abort
  " Wait until vim is ready to clone and configure or :PlugInstall will create the first window
  if get(s:, 'do_install', 0) == 1
    InstallSync
  endif
  " packloadall
  " Execute autocommands once the plugins are available
  call s:DoAutoCmd()
endfunction

" Add package (based on Plug command)
function! s:Pack(repo, ...) abort
  if a:0 > 1
    echoerr 'Invalid number of arguments (1..2)'
    return
  endif
  let l:repo = s:trim(a:repo)
  let l:opts = a:0 == 1 ? a:1 : {} " 'branch': 'master'
  let l:name = get(l:opts, 'as', fnamemodify(l:repo, ':t:s?\.git$??'))
  " l:dir -> g:, l:name . '_dir' ?
  let l:dir = get(l:opts, 'dir', g:pack_path . '/opt/' . l:name)
  " let spec = extend(s:infer_properties(l:name, l:repo), l:opts)
  " if !has_key(g:plugs, l:name)
  "   call add(g:plugs_order, l:name)
  " endif
  " echom 'Pack ' . l:name . ' (repo: ' . l:repo . ')'
  " let g:plugs[l:name] = spec
  " let s:loaded[l:name] = get(s:loaded, l:name, 0)
  if g:use_minpac
    if s:is_local(l:repo)
      if !isdirectory(l:dir)
        echom 'ln -s ' . l:repo . ' ' . l:dir
        execute 'silent !ln -s ' . l:repo . ' ' . l:dir
      endif
      let l:opts.frozen = get(l:opts, 'frozen', 1)
    else
      " " DONE: on VimEnter -> UpdateSync
      " let l:fmt = get(g:, 'plug_url_format', 'https://git::@github.com/%s.git')
      " let l:fmt = get(l:opts, 'fmt', l:fmt)
      " let l:url = printf(l:fmt, l:repo)
      " if !isdirectory(l:dir)
      "   call s:Clone(l:url, l:dir)
      " endif
      " " WARN: vim-plug = uri, minap = url
      " " let l:opts.url = get(l:opts, 'url', l:url)
    endif
    let l:opts.name = get(l:opts, 'name', l:name)
    let l:opts.type = get(l:opts, 'type', 'opt')

    " echom 'minpac add ' . l:repo
    " echo l:opts

    " Update &packpath
    call minpac#add(l:repo, l:opts)
    " Install plugin if missing
    " if !isdirectory(l:dir)
    "   call minpac#update(l:name)
    " endif
    " Load opt plugin (TODO: test start type)
    " if l:opts.type == 'opt'
    "   execute 'packadd' l:name
    " endif
    " echo minpac#getpluginfo(l:name)
  else
    Plug l:repo l:opts
  endif
  " try
  " catch
  "   return s:err(v:exception)
  " endtry
endfunction

function! s:Clone(url, path) abort
  echom 'Cloning ' . a:url . ' into ' . a:path
  execute 'silent !git clone --quiet ' . a:url . ' ' . a:path
endfunction

function! s:Load(...) abort
  if a:0 == 0
    echoerr 'Argument missing: path(s) required'
    return 1
  endif
  " let l:files = deepcopy(a:000)
  " let l:files = a:0 > 1 ? a:000 : a:1
  let l:files = a:0 > 1 ? a:000 : (type(a:1) == 1 ? [a:1] : a:1)
  call map(l:files, "printf('%s/%s.vim', $VIMCONFIG, v:val)")
  for l:path in l:files
    call s:Source(l:path)
  endfor
  call s:DoAutoCmd()
  if !g:use_minpac
    " Update &rtp
    call plug#end()
  endif
endfunction

function! s:DoAutoCmd(...) abort
  let l:group = a:0 ? a:1 : 'User'
  let l:event = a:0 > 1 ? a:2 : 'Config'
  if !exists('#' . l:group . '#' . l:event)
    return 1
  endif
  execute 'doautocmd <nomodeline>' l:group l:event
endfunction

function! s:Source(...) abort
  let l:path = a:0 > 0 ? a:1 : ''
  let l:expr = a:0 > 1 ? a:2 : ''
  if strlen(l:path) == 0
    echoerr 'Invalid argument: missing file path'
    return 0
  endif
  if strlen(l:expr) > 0
    if empty(filter([l:path], l:expr))
      return 0
    endif
  endif
  return s:SourceFile(l:path)
endfunction

function! s:SourceDir(...) abort
  let l:dir = a:1
  let l:expr = a:0 > 1 ? a:2 : ''
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
    if strlen(l:expr) > 0
      call s:Source(l:path, l:expr)
    else
      call s:Source(l:path)
    endif
  endfor
endfunction

function! s:SourceFile(path) abort
  if !filereadable(expand(a:path))
    return 0
  endif
  execute 'source' a:path
endfunction

function! s:GlobPath(...) abort
  if a:0 == 0
    echoerr 'Argument missing: path required'
    return 1
  endif
  let l:path = a:1
  let l:lead = a:0 > 1 ? a:2 : ''
  let l:expr = a:0 > 2 ? a:3 : "fnamemodify(v:val, ':t:r')"
  let l:filter_list = a:0 > 3 ? a:000[3:] : []
  let l:file_list = split(globpath(l:path, l:lead . '*.vim'), "\n")
  call map(l:file_list, l:expr)
  for l:filter in l:filter_list
    call filter(l:file_list, l:filter)
  endfor
  return l:file_list
endfunction

function! s:ListEnabled(ArgLead, CmdLine, CursorPos) abort
  let l:only_enabled = "get(g:, 'enable_' . v:val, 0) == 1"
  return s:GlobPath($VIMCONFIG, a:ArgLead, g:config_expr_name, l:only_enabled)
endfunction

function! s:ListDisabled(ArgLead, CmdLine, CursorPos) abort
  let l:exclude_init = "v:val !=# 'init'"
  let l:exclude_enabled = "get(g:, 'enable_' . v:val, 0) == 0"
  return s:GlobPath($VIMCONFIG, a:ArgLead, g:config_expr_name, l:exclude_init, l:exclude_enabled)
endfunction

let s:base_spec = {'branch': 'master'}
let s:TYPE = {
\   'string':  type(''),
\   'list':    type([]),
\   'dict':    type({}),
\   'funcref': type(function('call'))
\ }

function! s:trim(str)
  return substitute(a:str, '[\/]\+$', '', '')
endfunction

function! s:dirpath(path)
  return substitute(a:path, '[/\\]*$', '/', '')
endfunction

function! s:is_local(repo)
  return a:repo[0] =~ '[/$~]'
endfunction

function! s:define_commands() abort
  if g:use_minpac " packadd minpac
    command! -nargs=* -bar PackUpdate packadd minpac | call minpac#update(<f-args>)
    command! -nargs=* -bar PackClean packadd minpac | call minpac#clean(<f-args>)

    command! -nargs=* -bar Install PackUpdate
    command! -nargs=* -bar -bang Install PackUpdate
    command! -nargs=* -bar Update PackUpdate
    command! -nargs=* -bar -bang Update PackUpdate
    command! -nargs=* -bar Upgrade PackUpdate
    command! -nargs=* -bar InstallSync PackUpdate
  else
    command! -nargs=0 -bar Install PlugInstall
    command! -nargs=0 -bar -bang Install PlugInstall<bang>
    command! -nargs=0 -bar Update PlugUpdate
    command! -nargs=0 -bar -bang Update PlugUpdate<bang>
    command! -nargs=0 -bar Upgrade PlugUpgrade | PlugUpdate!
    command! -nargs=0 -bar InstallSync PlugInstall --sync
  endif
endfunction

command! -nargs=+ -bar Pack call config#(<args>)
command! -nargs=0 -bar Load call config#Load(<f-args>)
command! -nargs=* -bar -complete=customlist,s:ListEnabled Reload call config#Load(<f-args>)
command! -nargs=* -bar -complete=customlist,s:ListDisabled Enable call config#Load(<f-args>)
call s:define_commands()

" function! s:infer_properties(name, repo)
"   let l:repo = a:repo
"   if a:repo[0] =~ '[/$~]' " s:is_local_plug(l:repo)
"     return { 'dir': s:dirpath(expand(l:repo)) }
"   else
"     if l:repo =~ ':'
"       let l:uri = l:repo
"     else
"       if l:repo !~ '/'
"         throw printf('Invalid argument: %s (implicit `vim-scripts'' expansion is deprecated)', l:repo)
"       endif
"       let l:fmt = get(g:, 'plug_url_format', 'https://git::@github.com/%s.git')
"       let l:uri = printf(l:fmt, l:repo)
"     endif
"     return {'dir': s:dirpath(g:plug_home.'/'.a:name), 'uri': l:uri}
"   endif
" endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
