return {
  -- on_attach = function(_, bufnr)
  --   -- Hover actions
  --   vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr })
  --   -- Code action groups
  --   vim.keymap.set('n', '<Leader>a', rt.code_action_group.code_action_group, { buffer = bufnr })
  -- end,
  ['rust-analyzer'] = {
    cargo = {
      features = { 'all-features' },
    },
  },
}
