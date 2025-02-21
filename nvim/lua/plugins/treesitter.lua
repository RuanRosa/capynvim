return {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "lua", "vim", "vimdoc", "query" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
