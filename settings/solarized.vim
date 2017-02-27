" Solarized color scheme

try
  set background=dark
  colorscheme solarized
  call togglebg#map('<F5>')
catch /E185:/
  colorscheme default
endtry
