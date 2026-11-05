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

-- keep LazyVim's default English dictionary, add Brazilian Portuguese too
vim.opt.spelllang = { "en", "pt_br" }

-- custom spellfile for day-to-day tech jargon not covered by en/pt_br
-- (kubernetes, ansible, commitar, etc.) — versioned in the dotfiles repo so it
-- travels across machines; `zg` on a word appends to this file directly.
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/tech-jargon.utf-8.add"
