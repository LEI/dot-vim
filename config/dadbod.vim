" Database interface

Pack 'tpope/vim-dadbod' " Database interface
Pack 'kristijanhusak/vim-dadbod-ui' " Visual UI

highlight link dbui_saved_query dbui_buffers

" let g:db_ui_debug = 1

" let g:db_ui_dotenv_variable_prefix = 'DB_UI_'
" let g:db_ui_env_variable_name = 'DBUI_NAME'
" let g:db_ui_env_variable_url = 'DBUI_URL'

" let g:db_ui_execute_on_save = 1

" let g:db_ui_force_echo_notifications = 1

" let g:db_ui_hide_schemas = ['information_schema', 'pg_catalog'] " 'pg_toast_temp.*'

let g:db_ui_show_help = 0

if has('nvim')
  let g:db_ui_use_nerd_fonts = 1
  let s:expanded = ' '
  let s:collapsed = ' '
  let g:db_ui_icons = {
        \   'expanded': {
        \     'db': s:expanded . '',
        \     'buffers': s:expanded . '󰐐',
        \     'saved_queries': s:expanded . '',
        \     'schemas': s:expanded . '',
        \     'schema': s:expanded . 'פּ',
        \     'tables': s:expanded . '',
        \     'table': s:expanded . '',
        \   },
        \   'collapsed': {
        \     'db': s:collapsed . '',
        \     'buffers': s:collapsed . '󰐒',
        \     'saved_queries': s:collapsed . '',
        \     'schemas': s:collapsed . '',
        \     'schema': s:collapsed . 'פּ',
        \     'tables': s:collapsed . '',
        \     'table': s:collapsed . '',
        \   },
        \   'saved_query': '',
        \   'new_query': '󰓰',
        \   'tables': '󰓫',
        \   'buffers': '﬘',
        \   'add_connection': '',
        \   'connection_ok': '',
        \   'connection_error': '',
        \ }
endif

" Table helpers
" let g:db_ui_auto_execute_table_helpers = 0

let g:db_ui_table_helpers = {
      \   'postgresql': {
      \     'Count': 'select count(*) from "{schema}"."{table}"'
      \   }
      \ }

" let g:db_ui_tmp_query_location = '~/queries'

" let g:db_ui_winwidth = 30

" let g:db_ui_win_position = 'left'

let g:db_ui_disable_mappings = 1

augroup DadbodUI
  autocmd!

  autocmd FileType dbout
        \ call db_ui#utils#set_mapping('<C-]>', '<Plug>(DBUI_JumpToForeignKey)') |
        \ call db_ui#utils#set_mapping('vic', '<Plug>(DBUI_YankCellValue)') |
        \ call db_ui#utils#set_mapping('yh', '<Plug>(DBUI_YankHeader)') |
        \ call db_ui#utils#set_mapping('<Leader>R', '<Plug>(DBUI_ToggleResultLayout)')

  autocmd FileType dbui 
        \ call db_ui#utils#set_mapping(['o', '<CR>', '<2-LeftMouse>'], '<Plug>(DBUI_SelectLine)') |
        \ call db_ui#utils#set_mapping('S', '<Plug>(DBUI_SelectLineVsplit)') |
        \ call db_ui#utils#set_mapping('R', '<Plug>(DBUI_Redraw)') |
        \ call db_ui#utils#set_mapping('d', '<Plug>(DBUI_DeleteLine)') |
        \ call db_ui#utils#set_mapping('A', '<Plug>(DBUI_AddConnection)') |
        \ call db_ui#utils#set_mapping('H', '<Plug>(DBUI_ToggleDetails)') |
        \ call db_ui#utils#set_mapping('r', '<Plug>(DBUI_RenameLine)') |
        \ call db_ui#utils#set_mapping('q', '<Plug>(DBUI_Quit)') |
        \ call db_ui#utils#set_mapping('K', '<Plug>(DBUI_GotoFirstSibling)') |
        \ call db_ui#utils#set_mapping('J', '<Plug>(DBUI_GotoLastSibling)') |
        \ call db_ui#utils#set_mapping('p', '<Plug>(DBUI_GotoParentNode)') |
        \ call db_ui#utils#set_mapping('c', '<Plug>(DBUI_GotoChildNode)') |
        \ call db_ui#utils#set_mapping('gk', '<Plug>(DBUI_GotoPrevSibling)') |
        \ call db_ui#utils#set_mapping('gj', '<Plug>(DBUI_GotoNextSibling)') |
        \ nnoremap <buffer> g? ?

  autocmd FileType redis,sql
        \ call db_ui#utils#set_mapping('<C-s>', '<Plug>(DBUI_SaveQuery)') |
        \ call db_ui#utils#set_mapping('<Leader>E', '<Plug>(DBUI_EditBindParameters)') |
        \ call db_ui#utils#set_mapping('<Leader>S', '<Plug>(DBUI_ExecuteQuery)') |
        \ call db_ui#utils#set_mapping('<Leader>S', '<Plug>(DBUI_ExecuteQuery)', 'v')

  " autocmd User DBUIOpened let b:dotenv = DotenvRead('.envrc') | norm R
augroup END
