return {
  -- ./config/neoterm.vim

  {
    'fladson/vim-kitty',
    event = 'BufRead *.conf,*.session',
    cond = function()
      return vim.env.KITTY_WINDOW_ID ~= nil
    end,
    init = function()
      local group = vim.api.nvim_create_augroup('Kitty', { clear = true })

      vim.api.nvim_create_autocmd('BufRead', {
        group = group,
        pattern = 'kitty.conf',
        callback = function()
          vim.cmd('set filetype=kitty')
        end,
      })

      vim.api.nvim_create_autocmd('BufWritePost', {
        group = group,
        pattern = '~/.config/kitty/kitty.conf',
        callback = function()
          os.execute('kill -SIGUSR1 $(pgrep kitty)')
        end,
      })

      -- autocmd bufwritepost ~/.tmux.conf :silent !tmux source-file ~/.tmux.conf ; tmux display-message "Reloaded ~/.tmux.conf\!"
    end,
  },
}
