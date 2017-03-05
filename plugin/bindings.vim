" Key bindings

" Yank from the cursor to the end of the line
map Y y$

" Visually select the text that was last edited/pasted
nmap gV `[v`]

" Intuitive movement on wrapped lines
nnoremap j gj
nnoremap k gk
" nnoremap 0 g0
" nnoremap $ g$ " Do not use with :set wrap

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

" Paragraph reflow according to textwidth?
" vmap Q gv
" nmap Q gqap

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

" function! InsertTabWrapper()
"   if !pumvisible() && ()
"     return "\<Tab>"
"   else
"     return "\<C-n>"
"   endif
" endfunction

function! CheckBackSpace() abort
  let col = col('.') - 1
  " !col || getline('.')[col - 1] !~ '\k'
  return !col || getline('.')[col - 1] =~ '\s'
endfunction

function! s:cr_close_popup() abort
  return pumvisible() ? "\<C-y>" : "\<CR>"
  " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction

" Next and previous completion Tab and Shift-Tab
" inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : CheckBackSpace() ? "\<Tab>" : "\<C-n>"
" inoremap <S-Tab> <C-p> " Fix Shift-Tab? :exe 'set t_kB=' . nr2char(27) . '[Z'
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Select the completed word with Enter
" inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
" inoremap <CR> <C-r>=<SID>cr_close_popup()<CR>
" Close the popup menu (using <Esc> or <CR> breaks enter and arrow keys)
" inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<CR>"

" Change leader
let g:mapleader = "\<Space>"

" Sort selection
noremap <Leader>s :sort<CR>

" Quicker quit
noremap <Leader>q :q<CR>

" Save a file
noremap <Leader>w :w<CR>

" Write as root
noremap <Leader>W :w!!<CR>
