" Tern-based JavaScript support

" has('python') || has('python3')

if !executable('node') || !executable('npm')
  finish
endif

function! TernInstall(info)
  if a:info.status ==# 'installed' || a:info.force
    !npm install
  endif
endfunction

Plug 'ternjs/tern_for_vim', {'do': function('TernInstall'), 'for': 'javascript'}
