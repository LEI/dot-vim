" :Copilot setup

augroup Copilot
  autocmd!
  " Ignore dotenv and local files
  autocmd BufNewFile,BufRead .env,*.local let b:copilot_enabled = v:false
  " markdown,text,yaml
  autocmd FileType TelescopePrompt,dbout,gitcommit let b:copilot_enabled = v:false
  " Ignore all special buffers (nofile, prompt)
  autocmd BufWinEnter * if &buftype !=# '' | let b:copilot_enabled = v:false | endif
augroup END

Pack 'github/copilot.vim' " GitHub Copilot

" imap <silent><script><expr> <C-j> copilot#Accept("\<CR>")
imap <silent><script><expr> <C-l> copilot#Accept()
let g:copilot_no_tab_map = v:true

" <M-]> Cycle to the next suggestion, if one is available <Plug>(copilot-next)
imap <M-Right> <Plug>(copilot-next)

" <M-[> Cycle to the previous suggestion <Plug>(copilot-previous)
imap <M-Left> <Plug>(copilot-previous)

" <M-\> Explicitly request a suggestion <Plug>(copilot-suggest)
imap <M-Up> <Plug>(copilot-suggest)

" <C-]> Dismiss the current suggestion <Plug>(copilot-dismiss)
imap <M-Down> <Plug>(copilot-dismiss)
