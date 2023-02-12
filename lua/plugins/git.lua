local settings = require('core.settings')

return {
  -- Git blame line and signs column
  {
    'lewis6991/gitsigns.nvim',
    -- enabled = false,
    event = 'BufReadPre',
    opts = {
      -- -- TODO: move to core/settings.lua
      -- stylua: ignore
      signs = {
        add = { text = settings.signs.git.added },
        change = { text = settings.signs.git.modified },
        -- delete = { text = '_' },
        -- topdelete = { text = '‾' },
        changedelete = { text = settings.signs.git.modified },
        -- untracked = { text = '┆' },
      },
      current_line_blame = false, -- true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000 * 3,
        ignore_whitespace = true,
      },
      current_line_blame_formatter = ' <author>, <author_time:%R> - <summary>',
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map('n', ')h', gs.prev_hunk, 'Next Hunk')
        map('n', '(h', gs.next_hunk, 'Previous Hunk')
        map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
        map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
        map('n', '<Leader>gb', ':Gitsigns toggle_current_line_blame<CR>', 'Toggle Blame line')
        map('n', '<leader>ghS', gs.stage_buffer, 'Stage Buffer')
        map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
        map('n', '<leader>ghR', gs.reset_buffer, 'Reset Buffer')
        map('n', '<leader>ghp', gs.preview_hunk, 'Preview Hunk')
        map('n', '<leader>ghb', function()
          gs.blame_line({ full = true })
        end, 'Blame line (full)')
        map('n', '<leader>ghd', gs.diffthis, 'Diff This')
        map('n', '<leader>ghD', function()
          gs.diffthis('~')
        end, 'Diff This ~')
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
      end,
    },
  },

  -- Git conflict
  -- https://github.com/jesseduffield/lazygit
  -- https://github.com/akinsho/git-conflict.nvim
  -- https://github.com/rhysd/conflict-marker.vim
  -- http://vimcasts.org/episodes/fugitive-vim-resolving-merge-conflicts-with-vimdiff/
}
