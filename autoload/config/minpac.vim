" Config manager: minpac

" if v:version < 800
"   finish
" endif

let g:minpac_path = get(g:, 'minpac_path', g:pack_path . '/opt/minpac')
let g:minpac_url = get(g:, 'minpac_url', 'https://github.com/k-takata/minpac.git')

let g:minpac_opts = get(g:, 'minpac_opts', {'package_name': g:pack_dir})
" 'verbose': 0

let s:base_spec = {'branch': 'master'}
let s:TYPE = {
\   'string':  type(''),
\   'list':    type([]),
\   'dict':    type({}),
\   'funcref': type(function('call'))
\ }

let s:enabled = []

function! s:trim(str)
  return substitute(a:str, '[\/]\+$', '', '')
endfunction

function! s:dirpath(path)
  return substitute(a:path, '[/\\]*$', '/', '')
endfunction

function! s:IsLocal(repo)
  return a:repo[0] =~ '[/$~]'
endfunction

function! s:Clone(url, path) abort
  let l:fmt = 'git clone --depth 1 %s %s' " --quiet 2>&1
  let l:cmd = printf(l:fmt, a:url, a:path)
  let l:out = systemlist(l:cmd)
  if v:shell_error
    " echo substitute(l:out, '\n$', '', '')
    for l:l in l:out
      echoerr l:l
    endfor
  endif
  return v:shell_error
endfunction

function! config#minpac#init() abort
  if !isdirectory(g:minpac_path)
    call s:Clone(g:minpac_url, g:minpac_path)
    let s:do_install = 1
  endif
  if !isdirectory(g:minpac_path)
    let s:do_install = 0
    return 0
  endif
  packadd minpac
  " silent! exists('*minpac#init')
  call minpac#init(g:minpac_opts)
  call config#LoadDir()
  if get(s:, 'do_install', 0) == 1
    call minpac#update()
    " helptags ALL
  endif
  " let l:dir = g:pack_path . '/opt'
  " let l:expr = g:config_expr_enabled
  " Load optional plugins (packloadall)
  let l:files = minpac#getpackages(g:pack_dir, 'opt', '', 1)
  for l:name in s:enabled
    " echom 'packadd' l:name
    execute 'packadd' l:name
  endfor
endfunction

" Compatible with Plug command?
function! config#minpac#add(repo, ...) abort
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

  if s:IsLocal(l:repo)
      if !isdirectory(l:dir)
      echom 'ln -s ' . l:repo . ' ' . l:dir
      let l:out = system(printf('ln -s %s %s', l:repo, l:dir))
        if v:shell_error
            echoerr l:out
        endif
      endif
      let l:opts.frozen = get(l:opts, 'frozen', 1)
  else
      " " DONE: on VimEnter -> UpdateSync
      " let l:fmt = get(g:, 'plug_url_format', 'https://git::@github.com/%s.git')
      " let l:fmt = get(l:opts, 'fmt', l:fmt)
      " let l:url = printf(l:fmt, l:repo)
      " " WARN: vim-plug = uri, minap = url
      " " let l:opts.url = get(l:opts, 'url', l:url)
  endif
  let l:opts.name = get(l:opts, 'name', l:name)
  let l:opts.type = get(l:opts, 'type', 'opt')

  " echom 'minpac add ' . l:repo
  " echo l:opts

  let s:enabled = add(s:enabled, l:opts.name)

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
endfunction

function! config#minpac#define_commands() abort
  command! -nargs=* -bar PackUpdate packadd minpac | call minpac#update(<f-args>)
  command! -nargs=* -bar PackClean packadd minpac | call minpac#clean(<f-args>)

  command! -nargs=* -bar Install PackUpdate
  command! -nargs=* -bar -bang Install PackUpdate
  command! -nargs=* -bar Update PackUpdate
  command! -nargs=* -bar -bang Update PackUpdate
  command! -nargs=* -bar Upgrade PackUpdate
  command! -nargs=* -bar InstallSync PackUpdate
endfunction
