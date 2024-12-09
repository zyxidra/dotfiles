return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    delete_to_trash = true,
    float = {
      max_height = 45,
      max_width = 90,
    },
    keymaps = {
      ["q"] = "actions.close",
    },
    view_options = {
      show_hidden = true,
    },
  },
  config = function()
    vim.api.nvim_create_user_command("OilToggle", function()
      vim.cmd((vim.bo.filetype == "oil") and "bd" or "Oil --float")
    end, { nargs = 0 })
    vim.api.nvim_set_keymap("n", "<leader>e", ":OilToggle<CR>", { noremap = true, silent = true })
  end,
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
