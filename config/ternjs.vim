" Tern-based JavaScript support

" has('python') || has('python3')

if !executable('node') || !executable('npm')
  finish
endif

" let g:tern_map_keys = 1
" let g:tern_map_prefix = '<LocalLeader>'
" tD  :TernDoc
" tb  :TernDocBrowse
" tt  :TernType
" td  :TernDef
" tpd :TernDefPreview
" tsd :TernDefSplit
" ttd :TernDefTab
" tr  :TernRefs
" tR  :TernRename

if get(g:, 'use_minpac', v:version >= 800) == 1
  function! TernInstall(hooktype, name)
    " let l:info = minpac#getpluginfo(a:name)
    if a:hooktype == 'post-update'
      silent !npm install
    endif
  endfunction
else
  function! TernInstall(info)
    if a:info.status ==# 'installed' || a:info.force
      !npm install
    endif
  endfunction
endif

Pack 'ternjs/tern_for_vim', {'do': function('TernInstall'), 'for': 'javascript'}
