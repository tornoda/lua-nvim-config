-- dofile(vim.g.base46_cache .. "telescope")
local telescope_builtin = require "telescope.builtin"
local telescope = require "telescope"
local utils = require "utils"
local add_to_trouble = require("trouble.sources.telescope").add
local open_with_trouble = require("trouble.sources.telescope").open
local telescope_previewers = require "telescope.previewers"
local picker_label_width = 18

local function get_preview_lines(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return { "No preview available" }, nil
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local preview_limit = math.min(line_count, 200)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, preview_limit, false)

  if vim.tbl_isempty(lines) then
    lines = { "[Empty buffer]" }
  end

  return lines, vim.bo[bufnr].filetype
end

local function create_picker_previewer()
  return telescope_previewers.new_buffer_previewer {
    define_preview = function(self, entry)
      local preview_bufnr = self.state.bufnr
      local preview_lines = {}
      local source_bufnr
      local filetype

      if entry.kind == "tab" then
        local win = vim.api.nvim_tabpage_get_win(entry.value)
        source_bufnr = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(source_bufnr)
        local tab_label = buf_name == "" and "[No Name]" or vim.fn.fnamemodify(buf_name, ":~:.")

        preview_lines = {
          string.format("Tab %d", entry.index),
          string.format("Windows: %d", #vim.api.nvim_tabpage_list_wins(entry.value)),
          string.format("Buffer: %s", tab_label),
          "",
        }
      elseif entry.kind == "diffview" then
        source_bufnr = entry.bufnr
        preview_lines = {
          string.format("Diffview %s", entry.view_type),
          string.format("Tab: %d", entry.tabnr),
          string.format("Repo: %s", entry.repo),
          string.format("File: %s", entry.file_label),
        }

        if entry.rev_label and entry.rev_label ~= "" then
          preview_lines[#preview_lines + 1] = string.format("Rev: %s", entry.rev_label)
        end

        preview_lines[#preview_lines + 1] = ""
      elseif entry.kind == "divider" then
        preview_lines = { "Section divider" }
      else
        source_bufnr = entry.value
      end

      local content_lines
      content_lines, filetype = get_preview_lines(source_bufnr)
      vim.bo[preview_bufnr].modifiable = true
      vim.api.nvim_buf_set_lines(preview_bufnr, 0, -1, false, vim.list_extend(preview_lines, content_lines))
      vim.bo[preview_bufnr].modifiable = false
      vim.bo[preview_bufnr].filetype = filetype or ""
    end,
  }
end

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

-- Telescope keymaps have been moved to lua/keymaps.lua

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
    timeout = 100,      -- 减少预览超时
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

-- Export functions for keymaps.lua
local M = {}

M.select_tabs = function()
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local conf = require("telescope.config").values

  local tabs = vim.api.nvim_list_tabpages()
  if #tabs == 0 then
    vim.notify("No tabs available", vim.log.levels.INFO)
    return
  end

  local current_tab = vim.api.nvim_get_current_tabpage()
  local entries = {}

  for index, tab in ipairs(tabs) do
    local win = vim.api.nvim_tabpage_get_win(tab)
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    local display_name = buf_name == "" and "[No Name]" or vim.fn.fnamemodify(buf_name, ":~:.")
    local modified = vim.bo[buf].modified and " [+]" or ""
    local prefix = tab == current_tab and "*" or " "

    entries[#entries + 1] = {
      value = tab,
      kind = "tab",
      index = index,
      ordinal = string.format("%d %s", index, display_name),
      display = string.format("%s %d %s%s", prefix, index, display_name, modified),
    }
  end

  pickers.new({}, {
    prompt_title = "Tabs",
    finder = finders.new_table {
      results = entries,
      entry_maker = function(entry)
        return entry
      end,
    },
    sorter = conf.generic_sorter {},
    previewer = create_picker_previewer(),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection and selection.value then
          vim.api.nvim_set_current_tabpage(selection.value)
        end
      end)

      return true
    end,
  }):find()
end

M.select_buffers_and_tabs = function()
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local conf = require("telescope.config").values
  local diffview_lib = require "diffview.lib"
  local DiffView = require("diffview.scene.views.diff.diff_view").DiffView
  local FileHistoryView = require("diffview.scene.views.file_history.file_history_view").FileHistoryView

  local entries = {}
  local current_buf = vim.api.nvim_get_current_buf()

  for _, view in ipairs(diffview_lib.views) do
    local view_type = "view"
    if view:instanceof(DiffView) then
      view_type = "diff"
    elseif view:instanceof(FileHistoryView) then
      view_type = "history"
    end

    local repo = view.adapter and view.adapter.ctx and view.adapter.ctx.dir or "unknown"
    local current_file = view.cur_entry and view.cur_entry.path or "[No file]"
    local bufnr = nil

    if view.cur_entry and view.cur_entry.layout and view.cur_entry.layout.get_main_win then
      local main_win = view.cur_entry.layout:get_main_win()
      if main_win and main_win.file and main_win.file.bufnr and vim.api.nvim_buf_is_valid(main_win.file.bufnr) then
        bufnr = main_win.file.bufnr
      end
    end

    entries[#entries + 1] = {
      value = view,
      kind = "diffview",
      view_type = view_type,
      tabnr = view.tabpage and vim.api.nvim_tabpage_get_number(view.tabpage) or -1,
      repo = vim.fn.fnamemodify(repo, ":~"),
      file_label = current_file,
      rev_label = view.rev_arg,
      bufnr = bufnr,
      ordinal = string.format("diffview %s %s %s", view_type, repo, current_file),
      display = string.format(
        "  %-" .. picker_label_width .. "s %s %s",
        "[diffview " .. view_type .. "]",
        vim.fn.fnamemodify(repo, ":t"),
        current_file
      ),
    }
  end

  if #entries > 0 then
    entries[#entries + 1] = {
      value = nil,
      kind = "divider",
      ordinal = "zzzz divider buffers",
      display = string.format("  %-" .. picker_label_width .. "s %s", "", string.rep("-", 24) .. " buffers "),
    }
  end

  for _, buf in ipairs(vim.fn.getbufinfo { buflisted = 1 }) do
    local display_name = buf.name == "" and "[No Name]" or vim.fn.fnamemodify(buf.name, ":~:.")
    local modified = buf.changed == 1 and " [+]" or ""
    local prefix = buf.bufnr == current_buf and "*" or " "

    entries[#entries + 1] = {
      value = buf.bufnr,
      kind = "buffer",
      ordinal = string.format("buffer %d %s", buf.bufnr, display_name),
      display = string.format("%s %-" .. picker_label_width .. "s %s%s", prefix, "[buf " .. buf.bufnr .. "]", display_name, modified),
    }
  end

  pickers.new({}, {
    prompt_title = "Buffers and Diffviews",
    finder = finders.new_table {
      results = entries,
      entry_maker = function(entry)
        return entry
      end,
    },
    sorter = conf.generic_sorter {},
    previewer = create_picker_previewer(),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if not selection then
          return
        end

        if selection.kind == "divider" then
          return
        end

        if selection.kind == "diffview" then
          if selection.value and selection.value.tabpage and vim.api.nvim_tabpage_is_valid(selection.value.tabpage) then
            vim.api.nvim_set_current_tabpage(selection.value.tabpage)
          end
          return
        end

        if selection.kind == "buffer" then
          vim.cmd("buffer " .. selection.value)
        end
      end)

      return true
    end,
  }):find()
end

-- Smart search function for find files
M.smart_find_files = function()
  local telescope_builtin = require "telescope.builtin"

  -- Smart search: check if in nvim-tree
  local current_buf = vim.api.nvim_get_current_buf()
  local buf_type = vim.api.nvim_buf_get_option(current_buf, "filetype")

  if buf_type == "NvimTree" then
    local api = require "nvim-tree.api"
    local node = api.tree.get_node_under_cursor()
    if node then
      local node_path = node.absolute_path
      local search_path = node.type == "directory" and node_path or vim.fn.fnamemodify(node_path, ":h")
      telescope_builtin.find_files {
        search_dirs = { search_path },
        prompt_title = "Find Files in " .. vim.fn.fnamemodify(search_path, ":t"),
      }
    else
      telescope_builtin.find_files()
    end
  else
    telescope_builtin.find_files()
  end
end

-- Smart search function for live grep
M.smart_live_grep = function()
  local telescope_builtin = require "telescope.builtin"
  local utils = require "utils"

  -- Smart search: check if in nvim-tree
  local current_buf = vim.api.nvim_get_current_buf()
  local buf_type = vim.api.nvim_buf_get_option(current_buf, "filetype")

  local cur_word = utils.get_current_word()
  local _ret = string.find(cur_word, "[a-zA-Z_]+")
  local hasPre = _ret == 1
  local default_text = hasPre and "\\b" .. cur_word .. "\\b" or ""

  if buf_type == "NvimTree" then
    local api = require "nvim-tree.api"
    local node = api.tree.get_node_under_cursor()
    if node then
      local node_path = node.absolute_path
      local search_path = node.type == "directory" and node_path or vim.fn.fnamemodify(node_path, ":h")
      telescope_builtin.grep_string {
        cwd = search_path,
        search = ''
      }
    end
  elseif cur_word ~= "" then
    telescope_builtin.grep_string {
      search = cur_word
    }
  else
    telescope_builtin.live_grep {
      prompt_title = "Grep Search (regex:on case_sensitive:on)",
    }
  end
end

-- Find all files including hidden
M.find_all_files = function()
  local telescope_builtin = require "telescope.builtin"
  telescope_builtin.find_files {
    follow = true,
    no_ignore = true,
    hidden = true,
    prompt_title = "Find All Files",
  }
end

-- Find files in specific directory
M.find_files_in_directory = function()
  local telescope_builtin = require "telescope.builtin"
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
end

-- Grep in git modified files
M.grep_git_modified = function()
  local telescope_builtin = require "telescope.builtin"
  local utils = require "utils"
  local git_files = vim.fn.systemlist "git status --porcelain | awk '{print $2}'"

  if #git_files == 0 then
    print "No modified files"
    return
  end

  local cur_word = utils.get_current_word()
  local _ret = string.find(cur_word, "[a-zA-Z_]+")
  local hasPre = _ret == 1
  local default_text = hasPre and "\\b" .. cur_word .. "\\b" or ""

  telescope_builtin.live_grep {
    prompt_title = "Grep in Git Modified Files",
    search_dirs = git_files,
    default_text = default_text,
  }
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

      setHl()
    end,
  },
  -- Export functions for keymaps.lua
  extra = M,
}
