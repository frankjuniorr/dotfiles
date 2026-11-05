return {
	"NvChad/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		filetypes = { "*" },
		user_default_options = {
			RGB = true,
			RRGGBB = true,
			names = false,
			RRGGBBAA = true,
			AARRGGBB = false,
			rgb_fn = true,
			hsl_fn = true,
			css = false,
			css_fn = false,
			mode = "background",
			tailwind = false,
			virtualtext = "■",
			always_update = false,
		},
	},
}
