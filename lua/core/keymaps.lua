-- lua/core/keymaps.lua

local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- =============================================================================
-- Режим: Normal Mode (n)
-- =============================================================================

-- Сохранение (Ctrl+S) - ОСТАВИТЬ, полезно
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("v", "y", '"+y', { desc = "Yank to system clipboard", noremap = true, silent = true })

-- Навигация по окнам (<C-hjkl>) - ОСТАВИТЬ, стандартная и удобная
map("n", "<C-h>", "<C-w>h", { desc = "Окно слева", noremap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Окно снизу", noremap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Окно сверху", noremap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Окно справа", noremap = true })

-- Управление окнами (<leader>w...) - ОСТАВИТЬ, базовые операции с окнами
map("n", "<leader>wv", "<C-w>v", { desc = "Сплит вертикально", noremap = true })
map("n", "<leader>wh", "<C-w>s", { desc = "Сплит горизонтально", noremap = true })
map("n", "<leader>wq", "<C-w>q", { desc = "Закрыть окно", noremap = true }) -- Закрыть текущее окно
map("n", "<leader>wo", "<C-w>o", { desc = "Оставить только текущее окно", noremap = true })

-- Сохранение и выход (<leader>w, <leader>q, <leader>Q) - ОСТАВИТЬ, базовые команды
map("n", "<leader>w", ":write<CR>", { desc = "Сохранить", noremap = true, silent = true })
map(
	"n",
	"<leader>q",
	":quit<CR>",
	{ desc = "Выйти (если нет изменений)", noremap = true, silent = true }
)
map("n", "<leader>Q", ":qall!<CR>", { desc = "Выйти без сохранения", noremap = true, silent = true }) -- Будьте осторожны с этой!

-- --- Плагины ---

-- Telescope (<leader>f...) - ОСТАВИТЬ, это мощный поиск, вероятно, нужен
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
map("n", "<leader>fk", builtin.keymaps, { desc = "Поиск кейбиндов", noremap = true, silent = true }) -- Полезно для отладки биндов

-- Trouble (<leader>x...) - МОЖНО УДАЛИТЬ, если вы не пользуетесь Trouble для просмотра ошибок/диагностики
-- map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Trouble Toggle", silent = true })
-- map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Diagnostics", silent = true })
-- map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics", silent = true })
-- map("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "LSP References (Trouble)", silent = true }) -- gR может конфликтовать с gr из LSP

-- LSP (основные действия: K, gd, gD, gi, go, gr, <leader>d, [d, ]d) - ОСТАВИТЬ, это ключевые функции LSP
local lsp_opts = { noremap = true, silent = true }
map("n", "K", vim.lsp.buf.hover, lsp_opts)
map("n", "gd", vim.lsp.buf.definition, lsp_opts)
map("n", "gD", vim.lsp.buf.declaration, lsp_opts) -- Часто можно обойтись без gD, если gd хватает
map("n", "gi", vim.lsp.buf.implementation, lsp_opts)
map("n", "go", vim.lsp.buf.type_definition, lsp_opts) -- Можно убрать, если редко нужно
map("n", "gr", vim.lsp.buf.references, lsp_opts)
map("n", "<leader>d", vim.diagnostic.open_float, lsp_opts) -- Показать ошибку под курсором
map("n", "[d", vim.diagnostic.goto_prev, lsp_opts) -- К предыдущей ошибке
map("n", "]d", vim.diagnostic.goto_next, lsp_opts) -- К следующей ошибке

-- LSP Code Actions (<leader>ca) - ОСТАВИТЬ, очень полезно для рефакторинга, импортов и т.д.
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, lsp_opts)

-- LSP Rename (<leader>rn) - ОСТАВИТЬ, переименование важно
map("n", "<leader>rn", "<cmd>IncRename<CR>", { desc = "Incremental Rename", silent = true })

-- Форматирование (<leader>f) - УДАЛИТЬ, так как форматируете при сохранении
-- map({ "n", "v" }, "<leader>f", function()
--  require("conform").format({ async = true, lsp_fallback = true })
-- end, { desc = "Форматировать буфер", silent = true })

-- Линтинг (<leader>ll) - МОЖНО УДАЛИТЬ, если линтер запускается автоматически (например, при сохранении или через LSP)
-- map("n", "<leader>ll", function()
--  require("lint").try_lint()
-- end, { desc = "Запустить линтер", silent = true })

-- Symbols Outline (<leader>o) - МОЖНО УДАЛИТЬ, если не пользуетесь обзором символов
-- map("n", "<leader>o", "<cmd>SymbolsOutline<CR>", { desc = "Структура кода", silent = true })

-- Todo Comments (]t, [t) - МОЖНО УДАЛИТЬ, если не используете todo-comments активно
-- map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "След. TODO коммент", silent = true })
-- map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Пред. TODO коммент", silent = true })

-- Git (Diffview, Neogit) - УДАЛИТЬ, если не используете эти плагины
-- map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Git Diff View", silent = true })
-- map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "Git File History", silent = true })
-- map("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Neogit", silent = true })

-- =============================================================================
-- Режим: Insert Mode (i)
-- =============================================================================

-- Быстрый выход из Insert Mode (jk, kj) - ОСТАВИТЬ, популярно и удобно
map("i", "jk", "<ESC>", { desc = "Выход из Insert", noremap = true, silent = true })
map("i", "kj", "<ESC>", { desc = "Выход из Insert", noremap = true, silent = true })

-- --- nvim-cmp (Автодополнение) --- - ОСТАВИТЬ, критически важно для автодополнения
local cmp = require("cmp")
map("i", "<C-k>", cmp.mapping.select_prev_item(), { behavior = cmp.SelectBehavior.Select })
map("i", "<C-j>", cmp.mapping.select_next_item(), { behavior = cmp.SelectBehavior.Select })
map(
	"i",
	"<CR>",
	cmp.mapping.confirm({ select = true }),
	{ desc = "Подтвердить автодополнение" }
)
map("i", "<C-Space>", cmp.mapping.complete(), { desc = "Показать автодополнение" })
map("i", "<C-e>", cmp.mapping.abort(), { desc = "Закрыть автодополнение" })
-- Tab / S-Tab должны настраиваться в конфигурации cmp/luasnip

-- =============================================================================
-- Режим: Visual Mode (v)
-- =============================================================================

-- Отступы (>, <) - ОСТАВИТЬ, стандартные и нужные
map("v", ">", ">gv", { desc = "Увеличить отступ", noremap = true, silent = true })
map("v", "<", "<gv", { desc = "Уменьшить отступ", noremap = true, silent = true })

-- Перемещение строк (J, K) - МОЖНО УДАЛИТЬ, если не пользуетесь активно
-- map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Переместить вниз", noremap = true, silent = true })
-- map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Переместить вверх", noremap = true, silent = true })

-- =============================================================================
-- Режим: Command Mode (c)
-- =============================================================================
-- Оставить пустым, если нет специфичных нужд

print("Keymaps loaded successfully!")
