local M = {}

local state_file = vim.fn.stdpath "state" .. "/local-theme"

local themes = {
  {
    name = "tokyonight-moon",
    label = "Tokyonight Moon",
    apply = function()
      require("tokyonight").setup { style = "moon" }
      vim.cmd.colorscheme "tokyonight"
    end,
  },
  {
    name = "catppuccin-mocha",
    label = "Catppuccin Mocha",
    apply = function()
      require("lazy").load { plugins = { "catppuccin" } }
      require("catppuccin").setup { flavour = "mocha" }
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },
  {
    name = "kanagawa-wave",
    label = "Kanagawa Wave",
    apply = function()
      require("lazy").load { plugins = { "kanagawa.nvim" } }
      vim.cmd.colorscheme "kanagawa-wave"
    end,
  },
  {
    name = "kanagawa-dragon",
    label = "Kanagawa Dragon",
    apply = function()
      require("lazy").load { plugins = { "kanagawa.nvim" } }
      vim.cmd.colorscheme "kanagawa-dragon"
    end,
  },
  {
    name = "rose-pine-moon",
    label = "Rose Pine Moon",
    apply = function()
      require("lazy").load { plugins = { "rose-pine" } }
      vim.cmd.colorscheme "rose-pine-moon"
    end,
  },
  {
    name = "carbonfox",
    label = "Carbonfox",
    apply = function()
      require("lazy").load { plugins = { "nightfox.nvim" } }
      vim.cmd.colorscheme "carbonfox"
    end,
  },
  {
    name = "terafox",
    label = "Terafox",
    apply = function()
      require("lazy").load { plugins = { "nightfox.nvim" } }
      vim.cmd.colorscheme "terafox"
    end,
  },
  {
    name = "dracula",
    label = "Dracula",
    apply = function()
      require("lazy").load { plugins = { "dracula.nvim" } }
      vim.cmd.colorscheme "dracula"
    end,
  },
  {
    name = "onedark",
    label = "OneDark Pro",
    apply = function()
      require("lazy").load { plugins = { "onedarkpro.nvim" } }
      vim.cmd.colorscheme "onedark"
    end,
  },
  {
    name = "onedark_vivid",
    label = "OneDark Pro Vivid",
    apply = function()
      require("lazy").load { plugins = { "onedarkpro.nvim" } }
      vim.cmd.colorscheme "onedark_vivid"
    end,
  },
}

for _, theme in ipairs(require "themes.nvchad.registry") do
  themes[#themes + 1] = {
    name = theme.name,
    label = theme.label,
    apply = function()
      require("themes.nvchad." .. theme.module).apply()
    end,
  }
end

local by_name = {}

for _, theme in ipairs(themes) do
  by_name[theme.name] = theme
end

function M.list()
  return vim.deepcopy(themes)
end

function M.apply(name)
  local theme = by_name[name]
  if not theme then
    vim.notify("Unknown theme: " .. tostring(name), vim.log.levels.ERROR)
    return
  end

  theme.apply()
  vim.g.local_theme = theme.name
  vim.notify("Theme: " .. theme.label, vim.log.levels.INFO)
end

function M.apply_saved(default_name)
  local name = default_name
  local ok, saved = pcall(vim.fn.readfile, state_file)

  if ok and saved[1] and by_name[saved[1]] then
    name = saved[1]
  end

  M.apply(name)
end

function M.save(name)
  local theme = by_name[name]
  if not theme then
    vim.notify("Unknown theme: " .. tostring(name), vim.log.levels.ERROR)
    return
  end

  vim.fn.writefile({ theme.name }, state_file)
end

function M.picker()
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local conf = require("telescope.config").values

  pickers.new({}, {
    prompt_title = "Themes",
    finder = finders.new_table {
      results = themes,
      entry_maker = function(theme)
        return {
          value = theme,
          display = theme.label,
          ordinal = theme.name .. " " .. theme.label,
        }
      end,
    },
    sorter = conf.generic_sorter {},
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection and selection.value then
          M.save(selection.value.name)
          M.apply(selection.value.name)
        end
      end)

      return true
    end,
  }):find()
end

return M
