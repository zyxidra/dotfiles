return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>ue",
        function()
          require("edgy").toggle()
        end,
        desc = "Edgy Toggle",
      },
      {
        "<leader>uE",
        function()
          require("edgy").select()
        end,
        desc = "Edgy Select Window",
      },
    },
    opts = function()
      local opts = {
        bottom = {
          { title = "DAP Repl", ft = "dap-repl", size = { height = 15 } },
          { title = "DAP Console", ft = "dapui_console", size = { height = 15 } },
          { title = "Neotest Summary", ft = "neotest-summary" },
        },
        left = {
          {
            ft = "help",
            size = { height = 14, width = 100 },
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
        },
        right = {},
        keys = {
          -- Resize bindings
          ["<c-Right>"] = function(win)
            win:resize("width", 2)
          end,
          ["<c-Left>"] = function(win)
            win:resize("width", -2)
          end,
          ["<c-Up>"] = function(win)
            win:resize("height", 2)
          end,
          ["<c-Down>"] = function(win)
            win:resize("height", -2)
          end,
        },
      }
      return opts
    end,
  },
}
