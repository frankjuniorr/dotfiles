return {
	{
		"sainnhe/everforest",
		priority = 1000, -- Garante que o tema carregue cedo
		lazy = false,
		config = function()
			-- Opções globais do Everforest
			vim.g.everforest_background = "hard"
			vim.g.everforest_enable_italic = 1
			vim.g.everforest_better_performance = 1
			vim.g.everforest_transparent_background = 1
		end,
	},
}
