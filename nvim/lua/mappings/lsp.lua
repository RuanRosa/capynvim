vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {})

vim.keymap.set("n", "<leader>ld", function()
	vim.diagnostic.open_float()
end, {})
