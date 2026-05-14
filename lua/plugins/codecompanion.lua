return {
  "olimorris/codecompanion.nvim",
  version = "^19.0.0",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "MeanderingProgrammer/render-markdown.nvim",
    "HakonHarnes/img-clip.nvim",
  },
  opts = {
    -- Extensions
    extensions = {
      history = {
        enabled = true,
        opts = {
          -- In-chat keymaps (active inside a CodeCompanion chat buffer)
          keymap = "gh",              -- open history browser
          save_chat_keymap = "sc",    -- manual save
          auto_save = true,           -- auto-save every chat
          auto_generate_title = false, -- ACP does not support history title generation
          continue_last_chat = false, -- don't auto-restore last chat on startup
          delete_on_clearing_chat = false,
          expiration_days = 0,        -- never expire
          picker = "telescope",
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
          enable_logging = false,

          -- Summary system (gcs in chat to create, gbs to browse)
          summary = {
            create_summary_keymap = "gcs",
            browse_summaries_keymap = "gbs",
            generation_opts = {
              context_size = 90000,
              include_references = true,
              include_tool_outputs = true,
            },
          },
        },
      },
    },
    -- ACP adapters
    adapters = {
      acp = {
        codex = function()
          return require("codecompanion.adapters").extend("codex", {
            commands = {
              default = {
                "npx",
                "-y",
                "@zed-industries/codex-acp",
              },
            },
            env = {
              NPM_CONFIG_USERCONFIG = "/dev/null",
            },
            defaults = {
              auth_method = "chatgpt",
              -- In a chat buffer, use /acp_session_options to change Codex model
              -- and Reasoning Effort for the current ACP session.
              -- To set defaults, add session_config_options here, for example:
              -- session_config_options = {
              --   model = "gpt-5.4-mini",
              --   thought_level = "medium", -- Reasoning Effort: low|medium|high|xhigh
              -- },
            },
          })
        end,
        opencode = function()
          return require("codecompanion.adapters").extend("opencode", {
            commands = {
              default = {
                "opencode",
                "acp",
                "--cwd",
                vim.fn.stdpath("config"),
              },
            },
            env = {
              OPENCODE_CONFIG_DIR = vim.fn.expand("~/.config/opencode"),
            },
          })
        end,
      },
    },
    -- Interactions configuration
    interactions = {
      chat = {
        adapter = "codex",
        roles = {
          ---Display model name in the chat header instead of adapter name
          llm = function(adapter)
            local model_name = adapter.model and adapter.model.formatted_name
                or adapter.model and adapter.model.name
                or adapter.formatted_name
                or adapter.name
                or "AI"
            return "󰚩 CodeCompanion · " .. model_name
          end,
          user = " Yulong",
        },
      },
    },
    -- Display settings
    display = {
      action_palette = {
        provider = "telescope",
      },
      chat = {
        show_token_count = true,
        icons = {
          buffer_sync_all = "🔄 ",
          buffer_sync_diff = "📝 ",
          chat_context = "📎 ",
          chat_fold = "🧠 ",
          tool_pending = "⏳ ",
          tool_in_progress = "⚙️ ",
          tool_success = "✅ ",
          tool_failure = "❌ ",
        },
        window = {
          layout = "float",
          width = 0.85,
          height = 0.8,
          border = "rounded",
        },
      },
      diff = {
        enabled = true,
        close_chat_at = 240,
      },
    },
    -- General options
    opts = {
      log_level = "ERROR",
      send_code = true,
      use_default_actions = true,
      use_default_prompts = true,
      context_management = {
        enabled = true,
        trigger = 0.75, -- Percent of the context window (e.g., 0.75 for 75%)
      },
    },
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)
    require("codecompanion.config").display.chat.separator = nil

    local group = vim.api.nvim_create_augroup("CodeCompanionStaticTitles", { clear = true })
    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
      pattern = "codecompanion",
      group = group,
      callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "CodeCompanionChatSubmitted",
      group = group,
      callback = function(event)
        local chat = require("codecompanion.interactions.chat").buf_get_chat(event.data.bufnr)
        if not chat or chat.opts.title then
          return
        end

        local user_role = require("codecompanion.config").constants.USER_ROLE
        for _, message in ipairs(chat.messages or {}) do
          local content = message.content and vim.trim(message.content) or ""
          local is_context = message.opts and (message.opts.tag or message.opts.reference or message.opts.context_id)
          if message.role == user_role and content ~= "" and not is_context then
            content = content:gsub("%s+", " ")
            chat.opts.title = vim.fn.strcharpart(content, 0, 60)
            return
          end
        end
      end,
    })

    require("plugins.codecompanion.fidget-spinner"):init()
  end,
  keys = {
    -- Core windows
    { "<leader>cc", "<cmd>CodeCompanionChat<cr>",              desc = "CC: New Chat",          mode = { "n", "v" } },
    { "<leader>co", "<cmd>CodeCompanionChat opencode<cr>",     desc = "CC: OpenCode ACP Chat", mode = { "n", "v" } },
    { "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>",       desc = "CC: Toggle Chat",       mode = { "n", "v" } },
    { "<leader>ci", "<cmd>CodeCompanion<cr>",                  desc = "CC: Inline Prompt",     mode = { "n", "v" } },
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>",           desc = "CC: Action Palette",    mode = { "n", "v" } },
    { "<leader>cA", "<cmd>CodeCompanionChat Add<cr>",          desc = "CC: Add to Chat",       mode = "v" },
    { "<leader>cq", "<cmd>CodeCompanionCmd<cr>",               desc = "CC: Cmdline Prompt",    mode = "n" },

    -- Built-in slash command shortcuts (prompt library)
    { "<leader>ce", "<cmd>CodeCompanion /explain<cr>",         desc = "CC: Explain Code",      mode = { "n", "v" } },
    { "<leader>cf", "<cmd>CodeCompanion /fix<cr>",             desc = "CC: Fix Code",          mode = { "n", "v" } },
    { "<leader>cl", "<cmd>CodeCompanion /lsp<cr>",             desc = "CC: Explain LSP Diag",  mode = { "n", "v" } },
    { "<leader>cT", "<cmd>CodeCompanion /tests<cr>",           desc = "CC: Generate Tests",    mode = { "n", "v" } },
    { "<leader>cb", "<cmd>CodeCompanion /buffer<cr>",          desc = "CC: Chat about Buffer", mode = { "n", "v" } },
    { "<leader>cm", "<cmd>CodeCompanion /commit<cr>",          desc = "CC: Commit Message",    mode = "n" },
    { "<leader>cw", "<cmd>CodeCompanion /workflow<cr>",        desc = "CC: Workflow",          mode = { "n", "v" } },

    -- History (codecompanion-history.nvim extension)
    { "<leader>ch", "<cmd>CodeCompanionHistory<cr>",           desc = "CC: Chat History",      mode = "n" },
    { "<leader>cs", "<cmd>CodeCompanionSummaries<cr>",         desc = "CC: Browse Summaries",  mode = "n" },

    -- Cache management
    { "<leader>cR", "<cmd>CodeCompanionChat RefreshCache<cr>", desc = "CC: Refresh Cache",     mode = "n" },
    { "<leader>cP", "<cmd>CodeCompanionActions refresh<cr>",   desc = "CC: Refresh Prompts",   mode = "n" },
  },
}
