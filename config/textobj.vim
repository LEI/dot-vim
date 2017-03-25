" Text Objects

" Buffer operator (kana/vim-textobj-entire)
xnoremap i% GoggV
omap i% :<C-u>normal vi%<CR>

" Line operator
xnoremap il g_o0
omap il :<C-u>normal vil<CR>
xnoremap al $o0
omap al :<C-u>normal val<CR>

" Plug 'wellle/targets.vim' " Additional text objects

" Plug 'glts/vim-textobj-comment' | Plug 'kana/vim-textobj-user'
" Plug 'jceb/vim-textobj-uri' | Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-indent' | Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-line' | Plug 'kana/vim-textobj-user'
" Plug 'lucapette/vim-textobj-underscore' | Plug 'kana/vim-textobj-user'
" Plug 'rhysd/vim-textobj-conflict' | Plug 'kana/vim-textobj-user'

" Plug 'bkad/CamelCaseMotion' " CamelCase and snake_case
" Plug 'coderifous/textobj-word-column.vim' " Word-based columns
" Plug 'michaeljsmith/vim-indent-object' " Indent level
" Plug 'vim-scripts/argtextobj.vim' " Arguments

" for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '%', '`' ]
"   execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
"   execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
"   execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
"   execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
" endfor
