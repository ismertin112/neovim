-- lua/core/keymaps.lua
-- Центральный файл для всех пользовательских горячих клавиш

local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

-- [[ Настройка Leader ]]
vim.g.mapleader = " " -- Пробел как лидер
vim.g.maplocalleader = "\\"

print("Keymaps loading...")

-- =============================================================================
-- Режим: Normal Mode (n)
-- =============================================================================

-- Навигация (оставляем стандартной - НЕ переназначаем hjkl здесь!)

-- Навигация по окнам
map("n", "<C-h>", "<C-w>h", { desc = "Окно слева", noremap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Окно снизу", noremap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Окно сверху", noremap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Окно справа", noremap = true })

-- Управление окнами
map("n", "<leader>wv", "<C-w>v", { desc = "Сплит вертикально", noremap = true })
map("n", "<leader>wh", "<C-w>s", { desc = "Сплит горизонтально", noremap = true })
map("n", "<leader>wq", "<C-w>q", { desc = "Закрыть окно", noremap = true })
map("n", "<leader>wo", "<C-w>o", { desc = "Оставить только текущее окно", noremap = true })

-- Управление буферами
map("n", "[b", ":bprevious<CR>", { desc = "Предыдущий буфер", noremap = true, silent = true })
map("n", "]b", ":bnext<CR>", { desc = "Следующий буфер", noremap = true, silent = true })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Закрыть буфер", noremap = true, silent = true })

-- Сохранение и выход
map("n", "<C-s>", ":write<CR>", { desc = "Сохранить (Ctrl+S)", noremap = true, silent = true }) -- Ctrl+S в Normal
map("n", "<leader>w", ":write<CR>", { desc = "Сохранить (Leader+w)", noremap = true, silent = true })
map("n", "<leader>q", ":quit<CR>", { desc = "Выйти", noremap = true, silent = true })
map("n", "<leader>Q", ":qall!<CR>", { desc = "Выйти без сохранения", noremap = true, silent = true })

-- --- Плагины ---

-- NvimTree Toggle (Добавлено)
map(
	"n",
	"<leader>e",
	":NvimTreeToggle<CR>",
	{ desc = "Переключить NvimTree", noremap = true, silent = true }
)
-- Если используете neo-tree.nvim, замените на:
-- map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Переключить NeoTree", noremap = true, silent = true })

-- Telescope
local builtin = require("telescope.builtin")
map("n", "<leader>ff", builtin.find_files, { desc = "Поиск файлов", noremap = true, silent = true })
map("n", "<leader>fg", builtin.live_grep, { desc = "Поиск Grep", noremap = true, silent = true })
map("n", "<leader>fb", builtin.buffers, { desc = "Поиск буферов", noremap = true, silent = true })
map("n", "<leader>fh", builtin.help_tags, { desc = "Поиск Help", noremap = true, silent = true })
map(
	"n",
	"<leader>fo",
	builtin.oldfiles,
	{ desc = "Поиск недавних файлов", noremap = true, silent = true }
)
map("n", "<leader>fk", builtin.keymaps, { desc = "Поиск кейбиндов", noremap = true, silent = true })

-- Trouble (Диагностика)
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Trouble Toggle", silent = true })
map(
	"n",
	"<leader>xw",
	"<cmd>TroubleToggle workspace_diagnostics<cr>",
	{ desc = "Workspace Diagnostics", silent = true }
)
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics", silent = true })
map("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "LSP References (Trouble)", silent = true })

-- LSP (основные действия)
local lsp_opts = { noremap = true, silent = true }
--map("n", "K", vim.lsp.buf.hover, lsp_opts)
map("n", "gd", vim.lsp.buf.definition, lsp_opts)
map("n", "gD", vim.lsp.buf.declaration, lsp_opts) -- Исправлено на gD
map("n", "gi", vim.lsp.buf.implementation, lsp_opts)
map("n", "go", vim.lsp.buf.type_definition, lsp_opts)
map("n", "gr", vim.lsp.buf.references, lsp_opts)
map("n", "<leader>e", vim.diagnostic.open_float, lsp_opts) -- Ошибки/Предупреждения под курсором
map("n", "[d", vim.diagnostic.goto_prev, lsp_opts) -- Предыдущая ошибка
map("n", "]d", vim.diagnostic.goto_next, lsp_opts) -- Следующая ошибка

-- LSP Code Actions (в Normal и Visual режимах)
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, lsp_opts)

-- LSP Rename (используем IncRename)
map("n", "<leader>rn", "<cmd>IncRename<CR>", { desc = "Incremental Rename", silent = true })

-- Форматирование (conform.nvim)
map({ "n", "v" }, "<leader>f", function()
	-- Проверка наличия conform перед вызовом
	local conform_ok, conform = pcall(require, "conform")
	if conform_ok then
		conform.format({ async = true, lsp_fallback = true })
	else
		vim.notify("conform.nvim не найден", vim.log.levels.WARN)
	end
end, { desc = "Форматировать буфер", silent = true })

-- Линтинг (nvim-lint)
map("n", "<leader>ll", function()
	-- Проверка наличия nvim-lint перед вызовом
	local lint_ok, lint = pcall(require, "lint")
	if lint_ok then
		lint.try_lint()
	else
		vim.notify("nvim-lint не найден", vim.log.levels.WARN)
	end
end, { desc = "Запустить линтер", silent = true })

-- Symbols Outline
map("n", "<leader>o", "<cmd>SymbolsOutline<CR>", { desc = "Структура кода", silent = true })

-- Todo Comments
map("n", "]t", function()
	local todo_ok, todo = pcall(require, "todo-comments")
	if todo_ok then
		todo.jump_next()
	end
end, { desc = "След. TODO коммент", silent = true })
map("n", "[t", function()
	local todo_ok, todo = pcall(require, "todo-comments")
	if todo_ok then
		todo.jump_prev()
	end
end, { desc = "Пред. TODO коммент", silent = true })
-- map("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Поиск TODO (Telescope)", silent = true })

-- =============================================================================
-- Режим: Insert Mode (i)
-- =============================================================================

-- Сохранение из Insert Mode (Ctrl+S)
map("i", "<C-s>", "<ESC>:write<CR>a", { desc = "Сохранить (Ctrl+S)", noremap = true, silent = true })

-- Навигация (оставляем стандартной - НЕ переназначаем hjkl!)

-- Быстрый выход из Insert Mode (опционально)

-- --- nvim-cmp (Автодополнение) ---
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	print("WARN: nvim-cmp не найден, кейбинды для него не будут установлены.")
else
	local cmp_mapping = require("cmp.config.mapping") -- Получаем доступ к стандартным маппингам
	map(
		"i",
		"<C-k>",
		cmp_mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		{ desc = "Select prev completion" }
	)
	map(
		"i",
		"<C-j>",
		cmp_mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		{ desc = "Select next completion" }
	)
	map("i", "<CR>", cmp_mapping.confirm({ select = true }), { desc = "Confirm completion" })
	map("i", "<C-Space>", cmp_mapping.complete(), { desc = "Show completions" })
	map("i", "<C-e>", cmp_mapping.abort(), { desc = "Abort completion" })
	-- Tab/S-Tab используются для LuaSnip (настраивается в конфиге LuaSnip в plugins/cmp.lua)
end

-- =============================================================================
-- Режим: Visual Mode (v)
-- =============================================================================

-- Сохранение из Visual Mode (Ctrl+S)
map("v", "<C-s>", "<ESC>:write<CR>", { desc = "Сохранить (Ctrl+S)", noremap = true, silent = true })

-- Отступы
map("v", ">", ">gv", { desc = "Увеличить отступ", noremap = true, silent = true })
map("v", "<", "<gv", { desc = "Уменьшить отступ", noremap = true, silent = true })
map("i", "<C-k>", function()
	if cmp.visible() then
		cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
	end
end, { silent = true })
map("i", "<C-j>", function()
	if cmp.visible() then
		cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
	end
end, { silent = true })
-- =============================================================================
-- Режим: Command Mode (c)
-- =============================================================================
-- Не рекомендуется биндить <C-s> здесь без особой нужды

print("Keymaps loaded successfully!")
