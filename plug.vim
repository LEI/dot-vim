" Vim Plug

" Theme
Plug 'LEI/flattened' " altercation/vim-colors-solarized
" Plug 'LEI/vim-statusline'

" Improvments:
" Plug 'AndrewRadev/splitjoin.vim' " Line/multiline transitions
" Plug 'editorconfig/editorconfig-vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'} " Undo history visualizer
" Plug 'metakirby5/codi.vim' " Interactive scratchpad
" Plug 'tpope/vim-abolish' " Search, substitute and abbreviate variants
Plug 'tpope/vim-endwise' " Automatic end keywords
Plug 'tpope/vim-eunuch' " Helpers for UNIX shell commands
" Plug 'tpope/vim-obsession' " Continuously updated session files
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps
Plug 'tpope/vim-sleuth' " Automatic indentation detection (alt: ciaranm/detectindent)
Plug 'tpope/vim-surround' " Quoting/parenthesizing

" Navigation:
Plug 'tpope/vim-vinegar' " Improved netrw directory browser (alt: justinmk/vim-dirvish)

" Languages:
" Plug 'ternjs/tern_for_vim' " Tern-based JavaScript support

" Text Objects: kana/vim-textobj-user

" Formatting: google/vim-codefmt

" Syntax Checkers:
" scrooloose/syntastic, maralla/validator.vim
let g:enable_ale = 1
" let g:enable_neomake = 1
" Shell: bashate, shellcheck
" VimL: vim-vint
" Plug 'syngan/vim-vimlint' | Plug 'ynkdir/vim-vimlparser'

" Auto Completion:
if has('nvim') && has('python3') " pip3 install --upgrade neovim
  let g:enable_deoplete = 1
  let g:enable_neosnippet = 1
elseif has('lua')
  let g:enable_neocomplete = 1
  let g:enable_neosnippet = 1
endif
