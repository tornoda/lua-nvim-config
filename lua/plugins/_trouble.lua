-- filename with a _ prefix in order to making trouble open in telescope works
-- because Lazy.nvim loads pluigns one by one from top to bottom
local function set_mapping()
  local map = vim.keymap.set
  map({ "n", "v" }, "<leader>tt", "<cmd>Trouble<cr>", { desc = "Open trouble" })
  map({ "n", "v" }, "<leader>tc", function()
    require("trouble").close()
  end, { desc = "Close a trouble buffer" })
  map({ "n", "v" }, "<leader>tf", function()
    require("trouble").focus()
  end, { desc = "Focus trouble buffer" })
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
  opts = {
    -- pinned = true,
    auto_jump = true,
    preview = {
      type = "main",
      scratch = false,
    },
    focus = true,
    follow = false,
  },
  config = function(_, opts)
    require("trouble").setup(opts)
    set_mapping()
    set_autocmd()
  end,
}
