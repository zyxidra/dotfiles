return {
  {
    "akinsho/toggleterm.nvim",
    config = function()
      vim.keymap.set("n", "<leader>dt", function()
        local terms = require("toggleterm.terminal")
        local toggle = require("toggleterm").toggle

        -- Check if any terminal buffer is already open
        local term_open = false
        for _, term in pairs(terms.get_all()) do
          if term:is_open() then
            term_open = true
            term:toggle()
            return
          end
        end

        -- If no terminal is open, toggle the default terminal
        if not term_open then
          toggle(1) -- Opens the default terminal (ID 1)
        end
      end, { desc = "Toggle Terminal" })
    end,
  },
}
