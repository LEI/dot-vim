" Key bindings

" Yank from the cursor to the end of the line
map Y y$

" Visually select the text that was last edited/pasted
nmap gV `[v`]

" Move vertically on wrapped lines
nnoremap j gj
nnoremap k gk

" Restore visual selection after indent
vnoremap < <gv
vnoremap > >gv

" Split navigation shortcuts
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Bubble single or multiple lines
nmap <C-Up> ddkP
nmap <C-Down> ddp
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]

" Clear highlighted search results (vim-sensible: Ctrl-L)
nnoremap <Space> :nohlsearch<CR>

" Repeat latest f, t, F or T [count] times
noremap <Tab> ;

" Repeat last command on next match
noremap ; :normal n.<CR>

" Edit in the same directory as the current file
" cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

" Use <Left> and <Right> keys to move the cursor
" instead of selecting a different match:
" cnoremap <Left> <Space><BS><Left>
" cnoremap <Right> <Space><BS><Right>

" Save as root (or use :SudoWrite)
cmap w!! w !sudo tee % >/dev/null

" Insert a tab at the beginning of line if the popup menu is not visible
" or select the next completion
function! InsertTabWrapper()
  let col = col('.') - 1
  if !pumvisible() && (!col || getline('.')[col - 1] !~ '\k')
    return "\<Tab>"
  else
    return "\<C-n>"
  endif
endfunction

" Select next completion or insert a Tab
" inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <expr> <Tab> InsertTabWrapper()
" Select previous completion
inoremap <S-Tab> <C-p>
" Select the completed word with Enter
" inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
" Close the popup menu (using <Esc> or <BR> breaks enter and arrow keys)
" inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<CR>"

" Change leader
let g:mapleader = "\<Space>"

" Quicker quit
noremap <Leader>q :q<CR>

" Save a file
noremap <Leader>w :w<CR>

" Write as root
noremap <Leader>W :w!!<CR>
