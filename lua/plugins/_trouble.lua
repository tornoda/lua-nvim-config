-- filename with a _ prefix in order to making trouble open in telescope works
-- because Lazy.nvim loads pluigns one by one from top to bottom

local lsp_document_symbols = {
  desc = "document symbols",
  mode = "lsp_document_symbols",
  focus = false,
  win = { type = "split", size = 60, relative = "editor", position = "right" },
  filter = {
    -- remove Package since luals uses it for control flow structures
    ["not"] = { ft = "lua", kind = "Package" },
    any = {
      -- all symbol kinds for help / markdown files
      -- ft = { "help", "markdown" },
      -- default set of symbol kinds
      kind = {
        "Class",
        "Constructor",
        "Enum",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        "Package",
        "Property",
        "Struct",
        "Trait",
        "Constant"
      },
    },
  },
}

local opts = {
  -- pinned = true,
  auto_jump = true,
  auto_preview = false,
  preview = {
    type = "main",
    scratch = false,
  },
  focus = true,
  follow = false,
  win = { type = "split", size = 10, relative = "editor", position = "bottom" },
  modes = {
    -- more advanced example that extends the lsp_document_symbols
    symbols = {
      desc = "document symbols",
      mode = "lsp_document_symbols",
      focus = false,
      win = { position = "right", size = 80 },
      filter = {
        -- remove Package since luals uses it for control flow structures
        ["not"] = { ft = "lua", kind = "Package" },
        any = {
          -- all symbol kinds for help / markdown files
          ft = { "help", "markdown" },
          -- default set of symbol kinds
          kind = {
            "Class",
            "Constructor",
            "Enum",
            "Field",
            "Function",
            "Interface",
            "Method",
            "Module",
            "Namespace",
            "Package",
            "Property",
            "Struct",
            "Trait",
          },
        },
      },
    },
  },
}

-- Trouble keymaps have been moved to lua/keymaps.lua

local function set_autocmd()
  vim.api.nvim_create_autocmd("BufRead", {
    callback = function(ev)
      if vim.bo[ev.buf].buftype == "quickfix" then
        vim.schedule(function()
          vim.cmd [[cclose]]
          vim.cmd [[Trouble qflist open]]
        end)
      end
    end,
  })
end

return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  config = function(_)
    require("trouble").setup(opts)
    set_autocmd()
  end,
  extra = {
    open_lsp_document_symbols = function()
      -- local lsp_document_symbols = {
      --   desc = "document symbols",
      --   mode = "lsp_document_symbols",
      --   focus = false,
      --   win = { type = "split", size = 100, relative = "editor", position = "right" },
      -- }
      require("trouble").toggle(lsp_document_symbols)
    end,
  },
}
