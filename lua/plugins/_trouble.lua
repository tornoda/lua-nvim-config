-- filename with a _ prefix in order to making trouble open in telescope works
-- because Lazy.nvim loads pluigns one by one from top to bottom

local lsp_document_symbols = {
  desc = "document symbols",
  mode = "lsp_document_symbols",
  focus = false,
  win = { type = "split", size = 100, relative = "editor", position = "right" },
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
}

local function set_mapping()
  local map = vim.keymap.set
  map({ "n", "v" }, "<leader>tt", "<cmd>Trouble<cr>", { desc = "Open trouble" })

  map({ "n", "v" }, "<leader>tc", function()
    require("trouble").close()
  end, { desc = "Close a trouble buffer" })

  map({ "n", "v" }, "<leader>tf", function()
    require("trouble").focus()
  end, { desc = "Focus trouble buffer" })

  map({ "n", "v" }, "<C-p>", function()
    require("trouble").toggle(lsp_document_symbols)
  end, { desc = "Open Trouble lsp document symbols" })
  -- keys = {--   {
  --     "<leader>xx",
  --     "<cmd>Trouble diagnostics toggle<cr>",
  --     desc = "Diagnostics (Trouble)",
  --   },
  --   {
  --     "<leader>xX",
  --     "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  --     desc = "Buffer Diagnostics (Trouble)",
  --   },
  --   {
  --     "<leader>cs",
  --     "<cmd>Trouble symbols toggle focus=false<cr>",
  --     desc = "Symbols (Trouble)",
  --   },
  --   {
  --     "<leader>cl",
  --     "<cmd>Trouble lsp toggle focus=false<cr>",
  --     desc = "LSP Definitions / references / ... (Trouble)",
  --   },
  --   {
  --     "<leader>xL",
  --     "<cmd>Trouble loclist toggle<cr>",
  --     desc = "Location List (Trouble)",
  --   },
  --   {
  --     "<leader>xQ",
  --     "<cmd>Trouble qflist toggle<cr>",
  --     desc = "Quickfix List (Trouble)",
  --   },
  -- },
end

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
    set_mapping()
    set_autocmd()
  end,
}
