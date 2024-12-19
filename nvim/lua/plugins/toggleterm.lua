return {
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<leader>dt]],
        direction = "float",
        float_opts = {
          border = "rounded",
          width = 80,
          height = 25,
          winblend = 10,
        },
      })

      -- Optional: Define a custom toggle function
      vim.keymap.set("n", "<leader>dt", function()
        local terms = require("toggleterm.terminal")

        -- Check if any floating terminal is already open
        local term_open = false
        for _, term in pairs(terms.get_all()) do
          if term:is_open() and term.direction == "float" then
            term_open = true
            term:toggle()
            return
          end
        end

        -- If no terminal is open, toggle the default terminal
        if not term_open then
          terms.get_or_create(1):toggle()
        end
      end, { desc = "Toggle Floating Terminal" })
    end,
  },
}
