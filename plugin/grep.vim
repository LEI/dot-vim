" Grep options

if executable('ag')
  " Use Ag over Grep (additional options: --column, --ignore-case)
  set grepprg=ag\ --nocolor\ --nogroup\ --vimgrep
  " Command output format (default: "%f:%l:%m,%f:%l%m,%f  %l%m")
  set grepformat=%f:%l:%c:%m,%f:%l:%m

  " Bind \ (backward slash) to grep shortcut
  " command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  " nnoremap \ :Ag<SPACE>
endif
