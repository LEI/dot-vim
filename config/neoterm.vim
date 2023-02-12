" Terminal and REPL

Pack 'kassio/neoterm' " , { 'on': 'Topen' }
" Lua alternative: akinsho/toggleterm.nvim, hkupty/iron.nvim

let g:neoterm_default_mod = 'belowright' " open terminal in bottom split
let g:neoterm_direct_open_repl = v:true
" let g:neoterm_keep_term_open = v:false
" let g:neoterm_autoinsert = v:true
let g:neoterm_size = 16 " terminal split size
let g:neoterm_autoscroll = 1 " scroll to the bottom when running a command
" let g:neoterm_clear_cmd = { 'clear', '' }

" nnoremap <Leader><CR> :TREPLSendLine<CR>j " send current line and move down
" vnoremap <Leader><CR> :TREPLSendSelection<CR> " send current selection

" Send current line to REPL
nnoremap <Leader><CR> <Plug>(neoterm-repl-send-line)
" Send current selection to REPL
vnoremap <Leader><CR> <Plug>(neoterm-repl-send)

augroup NeoTermREPL
  autocmd!
  " if exists(':Artisan') | let g:neoterm_repl_php = 'php artisan tinker' | endif
  " TypeScript (node -r ts-node/register)
  autocmd FileType typescript
        \ if executable('./node_modules/.bin/ts-node') |
        \   call neoterm#repl#set('./node_modules/.bin/ts-node') |
        \ elseif executable('ts-node') |
        \   call neoterm#repl#set('ts-node') |
        \ end
augroup END
