return {
  {
    "sainnhe/everforest",
    priority = 1000, -- carrega antes de tudo
    config = function()
      -- Opções do tema (você pode customizar como quiser)
      vim.g.everforest_background = "hard" -- opções: 'soft', 'medium', 'hard'
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_better_performance = 1
      vim.g.everforest_transparent_background = 1

      vim.cmd("colorscheme everforest")
    end,
  },
}
