" Show invisible characters
set list

" set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
let &listchars = 'tab:' . nr2char(0x25B8) . ' '
let &listchars.= ',trail:' . nr2char(0x00B7)
let &listchars.= ',extends:' . nr2char(0x276F)
let &listchars.= ',precedes:' . nr2char(0x276E)
let &listchars.= ',nbsp:' . nr2char(0x005F)
let &listchars.= ',eol:' . nr2char(0x00AC)
