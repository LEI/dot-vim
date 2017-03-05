" Neosnippet

if !exists('g:loaded_neosnippet')
  finish
endif

" Conceal snippet markers
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Enter to close popup, or expand if a snippet is selected
" imap <expr> <CR> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-y>" : "\<CR>")

function! s:pmenu_close() abort
  if exists('g:popup_menu_close') && g:popup_menu_close !=# ''
    if exists('*' . g:popup_menu_close)
      return {g:popup_menu_close}()
    endif
    return g:popup_menu_close
  endif
  return "\<C-y>"
endfunction

let s:original_cr_imap = maparg('<CR>', 'i')
function! s:cr_pmenu_close(...) abort
  let l:cr = a:0 ? a:1 : s:original_cr_imap
  if pumvisible()
    return s:pmenu_close()
  endif
  if l:cr ==# '<CR><Plug>DiscretionaryEnd'
    return "\<CR>\<Plug>DiscretionaryEnd"
  elseif l:cr !=# ''
    return escape(l:cr, '<') " execute(l:cr)
  endif
  return "\<CR>"
  " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction

imap <expr> <CR> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : <SID>cr_pmenu_close()
" inoremap <CR> <C-r>=<SID>cr_close_popup()<CR>

" Expand snippet or jump to next placeholder
" imap <expr> <Tab> pumvisible() ? "\<C-n>" : neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
imap <expr> <C-l> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? <SID>pmenu_close() : "\<C-l>")
smap <expr> <C-l> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-l>"
xmap <C-l> <Plug>(neosnippet_expand_target)

" Jump to next placeholder without expanding snippet
imap <expr> <C-j> neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : "\<C-j>"
smap <expr> <C-j> neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : "\<C-j>"
" xmap <C-j> <Plug>(neosnippet_register_oneshot_snippet)
