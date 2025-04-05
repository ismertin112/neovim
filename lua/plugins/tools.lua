return {

	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		config = function()
			require("nvim-tree").setup({
				renderer = {
					icons = {
						glyphs = {
							folder = { default = "", open = "", empty = "", empty_open = "" },
						},
					},
					highlight_opened_files = "icon",
				},
				filters = { dotfiles = false, custom = { ".git", "node_modules", "__pycache__" } },
				git = { ignore = false },       -- ❗ Показывать файлы из .gitignore
				view = { width = 30, side = "left", adaptive_size = true }, -- ✅ Исправлено
				actions = { open_file = { quit_on_open = true } },
			})
		end,
	},
	-- 🔍 Мощный пои
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- { "nvim-telescope/telescope-fzf-native.nvim", build = ":RustBuild" }, -- Вы удалили эту строку
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		lazy = true,
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "node_modules", ".git/" },
					mappings = {
						i = {
							["<C-j>"] = require("telescope.actions").move_selection_next,
							["<C-k>"] = require("telescope.actions").move_selection_previous,
						},
					},
				},
				pickers = {
					find_files = { hidden = true }, -- 🔥 Искать скрытые файлы
					live_grep = {
						additional_args = function()
							return { "--hidden" }
						end,
					},
				},
				extensions = {
					-- fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true }, -- Удалите эту строку
					["ui-select"] = { require("telescope.themes").get_dropdown() },
					file_browser = { hijack_netrw = true },
				},
			})

			-- Подключаем расширения
			-- require("telescope").load_extension("fzf") -- Удалите эту строку
			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("file_browser")
		end,
	},
	-- 🖥️ Терминал внутри Neovim
	{
		"akinsho/toggleterm.nvim",
		lazy = false,
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<C-\>]],
				direction = "horizontal",
				size = 15,
				persist_size = true,
			})
		end,
	},

	-- 🛠 Поддержка GitLab CLI (glab)
	{
		"pwntester/octo.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		lazy = false,
		config = function()
			require("octo").setup()
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		config = function()
			vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { noremap = true, silent = true }) -- 🔥 Клавиша для запуска
		end,
	},
}
