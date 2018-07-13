" Initialize configuration

if exists('g:loaded_config')
  finish
endif

let g:loaded_config = 1

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

let s:manager = v:version >= 800 ? 'minpac' : 'plug'

let g:pack_dir = get(g:, 'pack_dir', 'config')
let g:pack_path = get(g:, 'minpac_path', $VIMHOME . '/pack/' . g:pack_dir)

let g:config_expr_name = "fnamemodify(v:val, ':t:r')"
let g:config_expr_enabled = "get(g:, 'enable_' . fnamemodify(v:val, ':t:r'), 0) == 1"

" Automatically install Vim Plug and configure enabled plugins
function! config#Init(...) abort
  if exists('v:vim_did_enter') && v:vim_did_enter
    echom 'Vim already started!'
    return
  endif
  " runtime autoload/plug
  call call(function('config#' . s:manager . '#init'), a:000)
  augroup UserConfig
    autocmd!
    autocmd VimEnter * call s:Init()
    " FIXME: User Config autocommands not cleared with 'autocmd! User Config'
    autocmd VimEnter * autocmd! UserConfig
    autocmd VimEnter * augroup! UserConfig
  augroup END
endfunction

function! s:Init() abort
  " Wait until vim is ready to clone and configure
  " or :PlugInstall will create the first window
  if get(s:, 'do_install', 0) == 1
    InstallSync
  endif
  " packloadall
  " Execute autocommands once the plugins are available
  call s:DoAutoCmd()
endfunction

" Add package / :packadd / :Load()
function! config#(...) abort
  " try
  " catch
  "   return s:err(v:exception)
  " endtry
  return call(function('config#' . s:manager . '#add'), a:000)
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

function! config#UserConfig(...) abort
  return call(function('s:DoAutoCmd'), a:000)
endfunction

function! s:DoAutoCmd(...) abort
  let l:group = a:0 ? a:1 : 'User'
  let l:event = a:0 > 1 ? a:2 : 'Config'
  if !exists('#' . l:group . '#' . l:event)
    return 1
  endif
  execute 'doautocmd <nomodeline>' l:group l:event
endfunction

function! config#Source(...) abort
  return call(function('s:Source'), a:000)
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

function! config#SourceDir(...) abort
  return call(function('s:SourceDir'), a:000)
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

command! -nargs=+ -bar Pack call config#(<args>)
command! -nargs=0 -bar Load call config#Load(<f-args>)
command! -nargs=* -bar -complete=customlist,s:ListEnabled Reload call config#Load(<f-args>)
command! -nargs=* -bar -complete=customlist,s:ListDisabled Enable call config#Load(<f-args>)
call call(function('config#' . s:manager . '#define_commands'), [])

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
