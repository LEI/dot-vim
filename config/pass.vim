" Password store

if !executable('pass')
  finish
endif

let s:redact_pass = '/usr/local/share/pass/contrib/vim/redact_pass.vim'

if filereadable(expand(s:redact_pass))
  execute 'source' s:redact_pass
endif
