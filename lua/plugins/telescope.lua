dofile(vim.g.base46_cache .. "telescope")
local telescope_builtin = require "telescope.builtin"
local telescope = require "telescope"
local utils = require "utils"
local add_to_trouble = require("trouble.sources.telescope").add
local open_with_trouble = require("trouble.sources.telescope").open

local function set_mapping()
  local map = vim.keymap.set
  map("n", "<leader><leader>", "<cmd>Telescope builtin<CR>", { desc = "Telescope builtin" })

  -- search the selection words
  map({ "v", "n" }, "<leader>fw", function()
    local cur_word = utils.get_current_word()
    local _ret = string.find(cur_word, "[a-zA-Z_]+")
    local hasPre = _ret == 1
    local default_text = hasPre and "\\b" .. cur_word .. "\\b" or ""

    telescope_builtin.live_grep {
      prompt_title = "Grep Search (regex:on case_sensitive:on)",
      default_text = default_text,
    }
  end, { desc = "Telescope find current word" })
  map("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope find in current buffer" })
  map("n", "f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope find in current buffer" })
  map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope find oldfiles" })
  map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope find files" })
  map(
    "n",
    "<leader>fa",
    "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
    { desc = "Telescope find all files" }
  )

  map("n", "<leader>jl", "<cmd>Telescope jumplist<CR>", { desc = "Telescope jumplist" })
  map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Telescope git_status" })
  map("n", "<leader>ic", "<cmd>Telescope lsp_incoming_calls<CR>", { desc = "Telescope lsp_incoming_calls" })
  map("n", "<leader>b", "<cmd>Telescope buffers<CR>", { desc = "Telescope find buffers" })
  map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope help page" })
  map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "Telescope find marks" })
  map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "Telescope git commits" })
  map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "Telescope pick hidden term" })
  map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "Telescope nvchad themes" })
end

local config = {
  vimgrep_arguments = {
    "rg",
    "-L",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
  },
  prompt_prefix = " 🍭 ",
  -- prompt_prefix = "   ",
  selection_caret = " 🌙 ",
  entry_prefix = "    ",
  initial_mode = "insert",
  selection_strategy = "reset",
  sorting_strategy = "ascending",
  -- layout_strategy = "horizontal",
  layout_strategy = "vertical",
  layout_config = {
    horizontal = {
      prompt_position = "top",
      preview_width = 0.55,
      results_width = 0.8,
    },
    bottom_pane = {
      height = 25,
      preview_cutoff = 8,
      prompt_position = "top",
    },
    vertical = {
      height = 0.9,
      preview_cutoff = 8,
      prompt_position = "top",
      width = 0.8,
    },
    width = 0.85,
    height = 0.40,
    preview_cutoff = 8,
  },
  file_sorter = require("telescope.sorters").get_fuzzy_file,
  file_ignore_patterns = { "node_modules" },
  generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
  path_display = { "truncate" },
  winblend = 0,
  border = {},
  borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  color_devicons = true,
  set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
  file_previewer = require("telescope.previewers").vim_buffer_cat.new,
  grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
  qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
  -- Developer configurations: Not meant for general override
  buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
  mappings = {
    n = {
      ["<leader>q"] = require("telescope.actions").close,
      ["q"] = require("telescope.actions").close,
    },
    i = {
      ["<c-l>"] = open_with_trouble,
      ["<c-a>"] = add_to_trouble,
      ["<C-j>"] = require("telescope.actions").move_selection_next,
      ["<C-k>"] = require("telescope.actions").move_selection_previous,
      ["<Down>"] = require("telescope.actions").cycle_history_next,
      ["<Up>"] = require("telescope.actions").cycle_history_prev,
    },
  },
}

local extensions_list = { "themes", "terms", "fzf", "ui-select", "projects" }

local options = {
  defaults = config,
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(vim.tbl_extend("force", config, {
        layout_config = {
          height = 0.5,
          width = 0.5,
        },
      })),

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    },
  },
}

return {
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "folke/trouble.nvim" },
    cmd = { "Telescope" },
    config = function()
      telescope.setup(options)

      for _, ext in ipairs(extensions_list) do
        telescope.load_extension(ext)
      end

      set_mapping()
    end,
  },
}
