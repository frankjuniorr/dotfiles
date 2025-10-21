-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.winbar = "%=%m %f"

-- yank command goes to clipboard too
vim.opt.clipboard = "unnamedplus"

vim.opt.guicursor = {
	"n-v-c:block", -- bloco nos modos normal/visual/command
	"i-ci-ve:ver25", -- i-beam (barra vertical) no modo insert
	"r-cr:hor20", -- underline nos modos replace
	"o:hor50", -- underline em operator-pending
}
