-- Seamless ctrl+h/j/k/l between nvim splits and the surrounding multiplexer.
-- Exactly one of the two plugins owns the chords per environment, because both
-- map the same keys: vim-tmux-navigator everywhere except inside herdr, and
-- herdr-nvim-nav (paired with the herdr-side plugin of the same name) inside herdr.
local in_herdr = vim.env.HERDR_ENV == "1"

return {
  {
    "christoomey/vim-tmux-navigator",
    -- cond (not enabled) so lazy keeps the plugin installed and in the lockfile
    -- while it is inactive inside herdr.
    cond = not in_herdr,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    -- lazy registers `keys` even for a cond=false plugin, so the mappings must
    -- be omitted inside herdr rather than relying on cond alone.
    keys = not in_herdr and {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    } or {},
  },
  {
    "aimdevlee/herdr-nvim-nav",
    commit = "ec047fd6d8d0269d54a34e9405af28d8aad4c8f0",
    cond = in_herdr,
    -- Not lazy-loaded on purpose: setup() writes the pane marker that tells the
    -- herdr side to forward ctrl+h/j/k/l here, so it must run before the first keypress.
    lazy = false,
    config = function()
      require("herdr-nvim-nav").setup({ with_tmux = false })
    end,
  },
}
