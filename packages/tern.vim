" Tern-based JavaScript support

function! TernInstall(info)
  if a:info.status ==# 'installed' || a:info.force
    !npm install
  endif
endfunction

Plug 'ternjs/tern_for_vim', {'do': function('TernInstall')}
