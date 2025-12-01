-- Autocommands shared across the configuration
local group = vim.api.nvim_create_augroup("CoreAutocmds", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

-- Better terminals
vim.api.nvim_create_autocmd("TermOpen", {
	group = group,
	callback = function()
		vim.bo[0].number = false
		vim.bo[0].relativenumber = false
	end,
})

-- Close some filetypes with q
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "help", "qf", "lspinfo", "spectre_panel", "startuptime" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})
