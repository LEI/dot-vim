" Configuration

" Vim Plug:
let g:plug_path = $VIMHOME . '/autoload/plug.vim'
let g:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

" General:
let g:enable_plugins = 1
let g:enable_unimpaired = 1

" Editing:
let g:enable_commentary = 1
let g:enable_splitjoin = 1
" let g:enable_tabular = 1

" VCS:
let g:enable_fugitive = 1

" Appearance:
let g:enable_colorscheme = 1
let g:enable_statusline = 1
let g:enable_tabline = 1

" Navigation:
let g:enable_ctags = 1
let g:enable_ctrlp = 1

" Languages:
let g:enable_polyglot = 1
let g:enable_tern = 1

" Syntax Checkers:
let g:enable_ale = 1
" let g:enable_neomake = 1
" scrooloose/syntastic, maralla/validator.vim, tomtom/checksyntax_vim...

" Auto Completion:
" let g:enable_youcompleteme = 1
" let g:enable_ultisnips = g:enable_youcompleteme
let g:enable_deoplete = has('nvim')
let g:enable_neocomplete = !has('nvim')
let g:enable_neosnippet = g:enable_deoplete || g:enable_neocomplete
