return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup {
      -- Manual mode: set to true to disable automatic directory changes
      manual_mode = true,

      -- Detection methods for project root (still useful for telescope projects)
      detection_methods = { "lsp", "pattern" },

      -- Patterns to detect project root
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

      -- Don't show hidden files in telescope
      show_hidden = false,

      -- Don't change directory silently
      silent_chdir = false,

      -- Scope of changing directory: 'global' | 'tab' | 'win'
      scope_chdir = 'global',
    }
  end,
}
