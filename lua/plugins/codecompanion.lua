-- Return the real value of an env var, or nil if unset/empty.
-- (Note: codecompanion HTTP adapters accept a name reference like "ANTHROPIC_API_KEY"
--  and resolve it themselves, but ACP adapters pass `env` straight to the child
--  process, so we MUST supply the real value here, not the variable name.)
local function env_value(name)
  local value = vim.env[name]
  if value and value ~= "" then
    return value
  end
end

-- Read the Claude Code OAuth token from the macOS Keychain. The `claude` CLI
-- stores it there after `claude setup-token`. Returns nil on any failure.
local function read_claude_token_from_keychain()
  if vim.fn.has("mac") ~= 1 or vim.fn.executable("security") ~= 1 then
    return nil
  end
  local raw = vim.fn.system({
    "security", "find-generic-password",
    "-s", "Claude Code-credentials", "-w",
  })
  if vim.v.shell_error ~= 0 or not raw or raw == "" then
    return nil
  end
  local ok, decoded = pcall(vim.json.decode, raw)
  if not ok or type(decoded) ~= "table" then
    return nil
  end
  local oauth = decoded.claudeAiOauth
  if type(oauth) == "table" and type(oauth.accessToken) == "string" and oauth.accessToken ~= "" then
    return oauth.accessToken
  end
  return nil
end


local function build_acp_adapters()
  local adapters = {
    opts = {
      show_presets = false,
    },
  }

  adapters.codex = function()
    return require("codecompanion.adapters").extend("codex", {
      commands = {
        default = { "npx", "-y", "@zed-industries/codex-acp" },
      },
      env = {
        NPM_CONFIG_USERCONFIG = "/dev/null",
      },
      defaults = {
        auth_method = "chatgpt",
      },
    })
  end

  adapters.claude_code = function()
    -- ACP env is forwarded verbatim to the spawned child process — must be a real
    -- token string, not a variable name. Prefer env var, fall back to Keychain.
    local oauth = env_value("CLAUDE_CODE_OAUTH_TOKEN") or read_claude_token_from_keychain()
    return require("codecompanion.adapters").extend("claude_code", {
      commands = {
        default = { "claude-agent-acp" },
      },
      env = oauth and { CLAUDE_CODE_OAUTH_TOKEN = oauth } or {},
    })
  end

  return adapters
end

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
    -- ACP adapters only — we authenticate via ChatGPT / Claude Code OAuth
    -- (no OpenAI API key), so HTTP adapters are not used.
    adapters = {
      acp = build_acp_adapters(),
      http = {
        opts = {
          show_presets = false,
        },
      },
    },
    -- Interactions configuration
    interactions = {
      chat = {
        adapter = "claude_code",
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
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)

    -- Neovim 0.11 follows __index chains when serializing nvim_exec_autocmds data.
    -- The adapter_modified object carries a metatable with Adapter.__index = Adapter
    -- (circular), causing "Lua failed to grow stack". Strip it from the event data.
    local cc_utils = require("codecompanion.utils")
    local _fire = cc_utils.fire
    cc_utils.fire = function(event, data)
      if data and data.adapter_modified then
        data = { agent_capabilities = data.agent_capabilities }
      end
      return _fire(event, data)
    end

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
    { "<leader>cc", "<cmd>CodeCompanionChat<cr>",              desc = "CC: New Chat (default)", mode = { "n", "v" } },
    { "<leader>cC", "<cmd>CodeCompanionChat claude_code<cr>",  desc = "CC: Claude ACP Chat",    mode = { "n", "v" } },
    { "<leader>cX", "<cmd>CodeCompanionChat codex<cr>",        desc = "CC: Codex ACP Chat",     mode = { "n", "v" } },
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
