return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Install the vscode-js-debug adapter
      {
        "microsoft/vscode-js-debug",
        -- After install, build it and rename the dist directory to out
        build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
        version = "1.*",
      },
      {
        "mxsdev/nvim-dap-vscode-js",
        dependencies = {
          "microsoft/vscode-js-debug",
          version = "1.x",
          build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
        },
        config = function()
          local dap = require("dap")
          --local utils = require 'dap.utils'
          local dap_js = require("dap-vscode-js")
          --local mason = require 'mason-registry'

          ---@diagnostic disable-next-line: missing-fields
          dap_js.setup({
            -- debugger_path = mason.get_package('js-debug-adapter'):get_install_path(),
            debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
            adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
          })

          local langs = { "javascript", "typescript", "svelte", "astro" }
          for _, lang in ipairs(langs) do
            dap.configurations[lang] = {
              {
                type = "pwa-node",
                request = "attach",
                name = "Attach debugger to existing `node --inspect` process",
                cwd = "${workspaceFolder}",
                skipFiles = {
                  "${workspaceFolder}/node_modules/**/*.js",
                  "${workspaceFolder}/packages/**/node_modules/**/*.js",
                  "${workspaceFolder}/packages/**/**/node_modules/**/*.js",
                  "<node_internals>/**",
                  "node_modules/**",
                },
                sourceMaps = true,
                resolveSourceMapLocations = {
                  "${workspaceFolder}/**",
                  "!**/node_modules/**",
                },
              },
            }
          end
        end,
      },
      {
        "Joakker/lua-json5",
        build = "./install.sh",
      },
    },
    opts = function()
      require("overseer").enable_dap()
    end,
    config = function()
      local js_based_languages = {
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact",
        "vue",
      }
      local dap = require("dap")
      for _, language in ipairs(js_based_languages) do
        dap.configurations[language] = {
          -- Debug single nodejs files
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug nodejs processes (make sure to add --inspect when you run the process)
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug web applications (client side)
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL: ",
                  default = "http://localhost:3000",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
          },
          -- Divider for the launch.json derived configs
          {
            name = "----- ↓ launch.json configs ↓ -----",
            type = "",
            request = "launch",
          },
        }
      end

      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7", -- if you use mason
      }
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = true,
        },
        {
          name = "Attach to gdbserver :1234",
          type = "cppdbg",
          request = "launch",
          MIMode = "gdb",
          miDebuggerServerAddress = "localhost:1234",
          miDebuggerPath = "/usr/bin/gdb",
          cwd = "${workspaceFolder}",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
        },
      }
      -- If you also want to debug C programs, add this:
      dap.configurations.c = dap.configurations.cpp

      local function focus_or_attach_dap(buffer_name, dap_ui_element)
        local found = false

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if buf_name:match(buffer_name) then
            vim.api.nvim_set_current_win(win) -- Focus the window
            found = true
            break
          end
        end

        if not found then
          require("dapui").open({ dap_ui_element })
        end
      end

      vim.keymap.set("n", "<leader>ds", function()
        focus_or_attach_dap("DAP Scopes", "scopes")
      end, { desc = "Focus or open DAP Scopes" })

      vim.keymap.set("n", "<leader>dr", function()
        focus_or_attach_dap("dap%-repl%-", "repl") -- Focus or attach to DAP Repl
      end, { desc = "Focus or Open DAP Repl" })
      --

      vim.keymap.set("n", "<leader>dx", function()
        if dap.session() then
          dap.terminate()
          print("DAP session terminated.")
        else
          print("No active DAP session.")
        end
      end, { desc = "Terminate DAP Session" })

      vim.keymap.set("n", "<leader>dq", function()
        require("dap").clear_breakpoints()
        print("All breakpoints cleared.")
      end, { desc = "Clear all DAP breakpoints" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-float",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
        end,
      })
      --
      -- Optional: Set up debugging keybindings
      vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "", linehl = "", numhl = "" })
      require("dap.ext.vscode").load_launchjs()
    end,
  },
}
