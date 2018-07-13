" Neosnippet

if v:version < 704
  finish
endif

Pack 'Shougo/neosnippet' | Pack 'Shougo/neosnippet-snippets'

" Conceal snippet markers
if has('conceal')
  set conceallevel=2
  set concealcursor=nv " niv
endif

" let g:neosnippet#snippets_directory = g:plug_home . '/vim-snippets/snippets'

" Jump to next placeholder
imap <C-j> <Plug>(neosnippet_jump_or_expand)
smap <C-j> <Plug>(neosnippet_jump_or_expand)
xmap <C-j> <Plug>(neosnippet_jump_or_expand)

" Expand snippet
imap <C-l> <Plug>(neosnippet_expand_or_jump)
smap <C-l> <Plug>(neosnippet_expand_or_jump)
xmap <C-l> <Plug>(neosnippet_expand_target)

" imap <expr> <Tab> pumvisible() ? "\<C-n>" : neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
" imap <expr> <C-l> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? <SID>pmenu_close() : "\<C-l>")

" " Enter to close popup, or expand if a snippet is selected
" imap <expr> <CR> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? <SID>pmenu_accept() : <SID>cr_imap())
" " Close popup menu and cancel completion
" imap <expr> <C-h> (pumvisible() ? <SID>pmenu_cancel() : "") . "\<C-h>"

function! s:pmenu_accept() abort
  if exists('g:popup_menu_accept') && g:popup_menu_accept !=# ''
    if exists('*' . g:popup_menu_accept)
      return {g:popup_menu_accept}()
    endif
    return g:popup_menu_accept
  endif
  " if (can complete)
  "   return "\<C-y>"
  " endif
  return "\<C-y>"
endfunction

function! s:pmenu_cancel() abort
  if exists('g:popup_menu_cancel') && g:popup_menu_cancel !=# ''
    if exists('*' . g:popup_menu_cancel)
      return {g:popup_menu_cancel}()
    endif
    return g:popup_menu_cancel
  endif
  return "\<C-e>"
endfunction

let s:original_cr_imap = maparg('<CR>', 'i')
function! s:cr_imap(...) abort
  let l:cr = a:0 ? a:1 : s:original_cr_imap
  if l:cr ==# '<CR><Plug>DiscretionaryEnd'
    return "\<CR>\<Plug>DiscretionaryEnd"
  elseif l:cr !=# ''
    return escape(l:cr, '<') " execute(l:cr)
  endif
  return "\<CR>"
  " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction
