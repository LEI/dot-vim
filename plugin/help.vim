" Help

function! VerticalHelp(topic)
  execute 'vertical botright help ' . a:topic
  execute 'vertical resize 78'
endfunction

" Open 80 columns vertical help woth :H <topic>
command! -complete=help -nargs=1 H call VerticalHelp(<f-args>)
