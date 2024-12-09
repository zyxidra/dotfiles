return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "nvim-neotest/nvim-nio",
  },
  opts = {
    layouts = {
      {
        elements = {
          { id = "repl", size = 0.05 }, -- 50% of the total height
        },
        size = 55,
        position = "right",
      },
    },
  },
  config = function(_, opts)
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup(opts)
    dap.listeners.before.attach.dapui_config = function()
      dapui.open({})
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open({})
    end
  end,
}
