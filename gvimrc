" Graphical vim options

try
  set guifont=Hack:h12 " Change the default font
catch /E596:/
endtry

set guioptions+=c " Use console dialogs
set guioptions-=T " Make the toolbar stay hidden after a restart
set guioptions-=r " Disable right-hand scrollbar
if &showtabline > 0
  set guioptions-=e " Use a non-GUI tab pages line
endif

" set backupcopy=yes " Prevent Finder file labels from disappearing

" set lines=
" set columns=

if has('gui_macvim')
  " set macmeta " Use option (alt) as meta key
  " set antialias " Smoother fonts, default on for MacVim
  " set blurradius=0 " When transparent, adds a blue effect to the background
  " set transparency=0 " Window background transparency percentage
  " set fullscreen " Enable fullscreen
  " set fuoptions=maxvert,maxhorz

  " Note: these have an effect only if 'Use Core Text renderer' is enabled
  " set macligatures " Display ligatures if the font supports them
  " set matchinstrokes " Lighter text rendering

  " Note: these should be added to .vimrc if has('gui_macvim')
  " let g:macvim_hig_shift_movement = 1 "Enable shift+movement selection
  " let g:macvim_skip_cmd_opt_movement = 1 " Disable mappings Cmd/Alt + arrow
endif

if filereadable($HOME . '/.gvimrc.local')
  source ~/.gvimrc.local
endif
