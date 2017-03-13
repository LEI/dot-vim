" Run Interactive

" https://github.com/christoomey/vim-run-interactive

function! s:RunInInteractiveShell(command)
  let l:saved_shellcmdflag = &shellcmdflag
  set shellcmdflag+=il
  try
    execute '!'. a:command
  finally
    execute 'set shellcmdflag=' . l:saved_shellcmdflag
  endtry
endfunction

command! -nargs=1 RunInInteractiveShell call <sid>RunInInteractiveShell(<f-args>)
