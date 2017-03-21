" Automatically create intermediate directories before writing the bufer
" https://github.com/pbrisbin/vim-mkdir

if exists('g:mkdir_loaded')
  finish
endif

let g:mkdir_loaded = 1

function! Mkdir(path)
  if exists('*mkdir')
    call mkdir(a:path, 'p')
  else
    execute '!mkdir' a:path
  endif
endfunction

function s:AutoMkdir()
  let l:dir = expand('%:p:h')
  if !isdirectory(l:dir)
    if confirm("Directory '" . l:dir . "' doesn't exists.", '&Create it?') == 1
      call Mkdir(l:dir)
      echo 'Created non-existing directory: ' . l:dir
    endif
  endif
endfunction

augroup AutoMkdir
  autocmd!
  " BufNewFile,BufWritePre,FileWritePre
  autocmd BufWritePre * call s:AutoMkdir()
augroup END
