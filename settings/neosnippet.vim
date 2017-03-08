" Neosnippet

if !exists('g:loaded_neosnippet')
  finish
endif

" Conceal snippet markers (FIXME: markdown)
if has('conceal')
  set conceallevel=2 " concealcursor=niv
endif

" Expand snippet or jump to next placeholder
" imap <expr> <Tab> pumvisible() ? "\<C-n>" : neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
" imap <expr> <C-l> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? <SID>pmenu_close() : "\<C-l>")
imap <expr> <C-j> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-j>"
smap <expr> <C-j> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-j>"
xmap <C-j> <Plug>(neosnippet_expand_target)
" xmap <C-j> <Plug>(neosnippet_register_oneshot_snippet)

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
