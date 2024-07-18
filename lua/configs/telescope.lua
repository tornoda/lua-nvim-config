dofile(vim.g.base46_cache .. "telescope")
local add_to_trouble = require("trouble.sources.telescope").add
local open_with_trouble = require("trouble.sources.telescope").open

local options = {
  defaults = {
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
    prompt_prefix = "   ",
    selection_caret = "* ",
    entry_prefix = "  ",
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
        ["q"] = require("telescope.actions").close,
        ["<c-l>"] = open_with_trouble,
        ["<c-a>"] = add_to_trouble,
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
  },
  extensions_list = { "themes", "terms", "fzf", "ui-select" },
  extensions = {},
}

return options
