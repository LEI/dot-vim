" Database interface

Pack 'tpope/vim-dadbod' " Database interface
Pack 'kristijanhusak/vim-dadbod-ui' " Visual UI

" Table helpers
"let g:db_ui_auto_execute_table_helpers = 1
let g:db_ui_table_helpers = {
\   'postgresql': {
\     'Count': 'select count(*) from "{schema}"."{table}"'
\   }
\ }

let g:db_ui_icons = {
\ 'expanded': '-',
\ 'collapsed': '+',
\ }
