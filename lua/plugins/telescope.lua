-- dofile(vim.g.base46_cache .. "telescope")
local telescope_builtin = require "telescope.builtin"
local telescope = require "telescope"
local utils = require "utils"
local add_to_trouble = require("trouble.sources.telescope").add
local open_with_trouble = require("trouble.sources.telescope").open

-- 智能搜索函数：根据当前上下文决定搜索范围
local function smart_search(search_func, search_options, fallback_options)
  -- 检查当前是否在nvim-tree中
  local current_buf = vim.api.nvim_get_current_buf()
  local buf_type = vim.api.nvim_buf_get_option(current_buf, "filetype")

  if buf_type == "NvimTree" then
    -- 在nvim-tree中，获取当前节点路径并在该路径下搜索
    local api = require "nvim-tree.api"
    local node = api.tree.get_node_under_cursor()

    if node then
      local node_path = node.absolute_path
      local search_path = node.type == "directory" and node_path or vim.fn.fnamemodify(node_path, ":h")
      local fullpath = vim.fn.fnamemodify(search_path, ":~")
      local search_tip = "Search in " .. fullpath

      -- 合并搜索选项
      local final_options = vim.tbl_extend("force", search_options or {}, {
        search_dirs = { search_path },
        prompt_title = search_options.prompt_title and search_options.prompt_title .. "(" .. search_tip .. ")"
          or search_tip,
        default_text = search_path and "",
      })

      -- 显示友好的提示信息
      vim.notify("🔍 Searching in: " .. fullpath, vim.log.levels.INFO)

      search_func(final_options)
    else
      -- 如果无法获取节点，回退到普通搜索
      vim.notify("⚠️  Could not determine search path, falling back to global search", vim.log.levels.WARN)
      search_func(fallback_options or search_options)
    end
  else
    -- 不在nvim-tree中，执行普通搜索
    search_func(fallback_options or search_options)
  end
end

local function set_mapping()
  local map = vim.keymap.set
  map("n", "<leader><leader>", "<cmd>Telescope builtin<CR>", { desc = "Telescope builtin" })

  -- search the selection words
  map({ "v", "n" }, "<leader>fw", function()
    local cur_word = utils.get_current_word()
    local _ret = string.find(cur_word, "[a-zA-Z_]+")
    local hasPre = _ret == 1
    local default_text = hasPre and "\\b" .. cur_word .. "\\b" or ""

    smart_search(telescope_builtin.live_grep, {
      prompt_title = "Grep Search (regex:on case_sensitive:on)",
      default_text = default_text,
    })
  end, { desc = "Telescope find current word (smart)" })
  map("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope find in current buffer" })
  map("n", "f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope find in current buffer" })
  map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Telescope find oldfiles" })
  map("n", "<leader>ff", function()
    smart_search(telescope_builtin.find_files, {
      prompt_title = "Find Files",
    })
  end, { desc = "Telescope find files (smart)" })
  map("n", "<leader>fl", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Telescope find lsp_document_symbols" })
  map(
    "n",
    "<leader>fs",
    "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
    { desc = "Telescope find lsp_dynamic_workspace_symbols" }
  )
  map("n", "<leader>fa", function()
    smart_search(telescope_builtin.find_files, {
      follow = true,
      no_ignore = true,
      hidden = true,
      prompt_title = "Find All Files",
    })
  end, { desc = "Telescope find all files (smart)" })

  -- 手动指定搜索目录
  map("n", "<leader>fd", function()
    local input = vim.fn.input "Enter search directory: "
    if input and input ~= "" then
      local expanded_path = vim.fn.expand(input)
      if vim.fn.isdirectory(expanded_path) == 1 then
        telescope_builtin.find_files {
          search_dirs = { expanded_path },
          prompt_title = "Find Files in " .. vim.fn.fnamemodify(expanded_path, ":t"),
        }
      else
        vim.notify("❌ Invalid directory: " .. expanded_path, vim.log.levels.ERROR)
      end
    end
  end, { desc = "Telescope find files in specific directory" })

  -- 快捷键：在 git modified 文件中搜索文本
  map("n", "<leader>fg", function()
    -- 获取 git status 下的文件列表
    local git_files = vim.fn.systemlist "git status --porcelain | awk '{print $2}'"

    if #git_files == 0 then
      print "No modified files"
      return
    end

    local cur_word = utils.get_current_word()
    local _ret = string.find(cur_word, "[a-zA-Z_]+")
    local hasPre = _ret == 1
    local default_text = hasPre and "\\b" .. cur_word .. "\\b" or ""

    require("telescope.builtin").live_grep {
      prompt_title = "Grep in Git Modified Files",
      search_dirs = git_files,
      default_text,
    }
  end, { desc = "Telescope: grep in git modified files" })

  map("n", "<leader>jl", "<cmd>Telescope jumplist<CR>", { desc = "Telescope jumplist" })
  map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Telescope git_status" })
  map("n", "<leader>ic", "<cmd>Telescope lsp_incoming_calls<CR>", { desc = "Telescope lsp_incoming_calls" })
  map("n", "<leader>b", "<cmd>Telescope buffers<CR>", { desc = "Telescope find buffers" })
  map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Telescope help page" })
  map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "Telescope find marks" })
  map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "Telescope pick hidden term" })
  --
  map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Telescope git commits" })
  map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Telescope get git branches" })
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
    -- 性能优化：限制搜索结果
    "--max-count=1000",
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
  file_ignore_patterns = {
    "node_modules",
    ".git",
    ".cache",
    -- "dist",
    "build",
    "*.pyc",
    "__pycache__",
  },
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

  -- 性能优化配置
  cache_picker = {
    num_pickers = -1,
  },

  -- 限制预览大小
  preview = {
    treesitter = false, -- 禁用 Tree-sitter 预览
    timeout = 100, -- 减少预览超时
  },

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

local function setHl()
  local function set_preview_line_highlight()
    --  respecting to the color for DiffAdd
    --  search setColor for more details
    local color = vim.o.background ~= "dark" and "#3b643b" or "#d7eed8"
    vim.api.nvim_set_hl(0, "TelescopePreviewLine", {
      -- bg = vim.api.nvim_get_hl(0, { name = "DiffAdd" }).bg,
      bg = color,
      italic = true,
    })
  end

  set_preview_line_highlight()

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_preview_line_highlight,
  })
end

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
      setHl()
    end,
  },
}
