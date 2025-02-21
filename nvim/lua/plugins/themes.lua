return {
	{
		"Tsuzat/NeoSolarized.nvim",
	},
	{
		"slugbyte/lackluster.nvim",
	},
	{
		"sainnhe/sonokai",
	},
	{
		"sho-87/kanagawa-paper.nvim",
	},
	{
		"gabivlj/torte",
	},
	{
		"darkvoid-theme/darkvoid.nvim",
	},
	{
		'projekt0n/github-nvim-theme',
		name = 'github-theme',
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require('github-theme').setup({
				-- ...
			})
		end,
	},
	{
		"xero/miasma.nvim",
	},
}
