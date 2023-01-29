-- https://github.com/askfiy/nvim/blob/master/init.lua
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
if not vim.fn.has('nvim-0.8') then
  assert(false, 'nvim-0.8 required')
end

require('core.lazy')
