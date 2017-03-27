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

function! TernInstall(info)
  if a:info.status ==# 'installed' || a:info.force
    !npm install
  endif
endfunction

Plug 'ternjs/tern_for_vim', {'do': function('TernInstall'), 'for': 'javascript'}
