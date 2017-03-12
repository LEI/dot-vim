" Vim Plug

" Plug 'editorconfig/editorconfig-vim'
" Plug 'LEI/vim-statusline'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'} " Undo history visualizer
" Plug 'metakirby5/codi.vim' " Interactive scratchpad
" Plug 'tpope/vim-abolish' " Search, substitute and abbreviate variants
Plug 'tpope/vim-endwise' " Automatic end keywords
Plug 'tpope/vim-eunuch' " Helpers for UNIX shell commands
" Plug 'tpope/vim-obsession' " Continuously updated session files
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps
Plug 'tpope/vim-sleuth' " Automatic indentation detection (alt: ciaranm/detectindent)
Plug 'tpope/vim-surround' " Quoting/parenthesizing
Plug 'tpope/vim-vinegar' " Improved netrw directory browser (alt: justinmk/vim-dirvish)

" Text Objects: kana/vim-textobj-user

" Formatting: google/vim-codefmt

" Syntax Checkers: scrooloose/syntastic, maralla/validator.vim
" let g:enable_neomake = has('nvim') || v:version > 704 || v:version == 704 && has('patch503')
let g:enable_ale = has('nvim') || v:version >= 800

" Auto Completion:
let g:enable_ycm = 0 " has('python') || has('python3')
let g:enable_ultisnips = g:enable_ycm
" let g:enable_deoplete = has('nvim') && has('python3')
" let g:enable_neocomplete = !has('nvim') && has('lua')
" let g:enable_neosnippet = g:enable_deoplete || g:enable_neocomplete
