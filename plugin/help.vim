" Help

function! VerticalHelp(...)
  let l:topic = a:0 ? a:1 : ''
  execute 'vertical botright help' l:topic
  execute 'vertical resize 78'
endfunction

" Use :H to open a narrow help split
command! -complete=help -nargs=? H call VerticalHelp(<f-args>)
