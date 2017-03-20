" Check characters before the cursor

function! MayComplete() abort
  let l:col = col('.') - 1
  if !l:col || getline('.')[l:col - 1] !~# '\k'
    return 0
  endif
  return 1
endfunction
