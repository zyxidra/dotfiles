-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

require("hbac").setup({
  autoclose = true,
  threshold = 3,
  close_command = function(bufnr)
    vim.api.nvim_buf_delete(bufnr, {})
  end,
  close_buffers_with_windows = false,
})
require("overseer").setup({
  dap = true,
  strategy = "toggleterm",
})
require("overseer").enable_dap()
require("toggleterm").setup({})
require("oil").setup()
