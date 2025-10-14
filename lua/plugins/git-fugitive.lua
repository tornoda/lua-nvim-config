return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gblame", "Gbrowse" }, -- 懒加载：当这些命令被调用时加载
    keys = {
      -- { "<leader>gs", ":Git status<CR>", desc = "Git status" },
      -- { "<leader>ga", ":Git add %<CR>", desc = "Git add current file" },
      -- { "<leader>gc", ":Git commit<CR>", desc = "Git commit" },
      -- { "<leader>gp", ":Git push<CR>", desc = "Git push" },
      -- { "<leader>gb", ":Git blame<CR>", desc = "Git blame" },
    },
  },
}
