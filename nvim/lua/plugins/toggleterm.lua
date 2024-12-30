return {
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        persist_mode = true,
      })
    end,
  },
}
