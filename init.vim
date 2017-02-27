" Vim

function! Exists(path)
  return filereadable(expand(a:path))
endfunction

runtime before.vim

runtime plug.vim

runtime config.vim

if Exists('~/.vimrc.local')
  source ~/.vimrc.local
endif
