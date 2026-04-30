-- do
--   return {}
-- end
--
vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })

local function register_dap()
  require("dap").adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      -- 💀 Make sure to update this path to point to your installation
      args = { vim.fn.stdpath "config" .. "/.ext/js-debug/src/dapDebugServer.js", "${port}" },
    },
  }
end

local function config_dap()
  local js_based_languages = { "typescript", "javascript", "typescriptreact" }

  for _, language in ipairs(js_based_languages) do
    require("dap").configurations[language] = {
      -- {
      --   type = "pwa-node",
      --   request = "launch",
      --   name = "Launch TS",
      --   program = "${file}",
      --   cwd = vim.fn.getcwd(),
      --   runtimeExecutable = "node",
      --   runtimeArgs = { "--loader", "ts-node/esm" },
      --   sourceMaps = true,
      --   protocol = "inspector",
      --   console = "integratedTerminal",
      -- },
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Auto Attach",
        sourceMaps = true,
        cwd = vim.fn.getcwd(),
        skipFiles = { "<node_internals>/**" },
        -- processId = require("dap.utils").pick_process,
      },
      -- {
      --   type = "pwa-chrome",
      --   request = "launch",
      --   name = 'Start Chrome with "localhost"',
      --   -- url = "http://localhost:3000",
      --   url = "http://localhost:8080",
      --   webRoot = "${workspaceFolder}",
      --   userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
      -- },
    }
  end
end

return {
  -- {
  --   "microsoft/vscode-js-debug",
  --   lazy = false,
  --   build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  -- },
    {
      "mfussenegger/nvim-dap",
      cmd = { "DapContinue", "DapTerminate", "DapToggleBreakpoint", "DapStepOver", "DapStepInto", "DapStepOut" },
      keys = {
        { "<F5>", function() require("dap").continue() end, desc = "DAP Continue" },
        { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
        { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
        { "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
        {
          "<leader>B",
          function()
            require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
          end,
          desc = "DAP Conditional Breakpoint",
        },
      },
      config = function()
        register_dap()
        config_dap()
      end,
    },
  -- {
  --   lazy = false,
  --   "mxsdev/nvim-dap-vscode-js",
  --   dependencies = { "mfussenegger/nvim-dap" },
  --   config = function()
  --     require("dap-vscode-js").setup {
  --       -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  --       -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
  --       -- debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
  --       debugger_path = vim.fn.stdpath "config" .. "/.ext/vscode-js-debug", -- Path to vscode-js-debug installation.
  --       -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  --       adapters = {
  --         -- "chrome",
  --         "pwa-node",
  --         -- "pwa-chrome",
  --         -- "pwa-msedge",
  --         -- "node-terminal",
  --         -- "pwa-extensionHost",
  --         -- "node",
  --         -- "chrome",
  --       }, -- which adapters to register in nvim-dap
  --       -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  --       -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  --       -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
  --     }
  --     -- 解析 VS Code 的 launch.json
  --     -- local dap_vscode = require "dap.ext.vscode"
  --     -- dap_vscode.load_launchjs(nil, { ["pwa-node"] = { "javascript", "typescript" } })
  --     -- require("dap").adapters["pwa-node"] = {
  --     --   type = "server",
  --     --   host = "127.0.0.1",
  --     --   port = 9229, -- 这个端口必须和 Node.js `--inspect` 端口匹配
  --     -- }
  --   end,
  -- },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()

      local dap, dapui = require "dap", require "dapui"

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
