" Vim

function! Exists(path)
  return filereadable(expand(a:path))
endfunction

runtime before.vim

runtime config.vim

runtime plug.vim

if Exists('~/.vimrc.local')
  source ~/.vimrc.local
endif
