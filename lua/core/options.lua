-- lua/core/options.luaopt
-- Основные настройки Neovim

local opt = vim.opt -- для краткости
local g = vim.g -- для краткости

-- [[ Визуальные настройки ]]
opt.termguicolors = true -- Включить 24-битный цвет (True Color)
opt.number = true -- Показывать номера строк
opt.relativenumber = true -- Показывать относительные номера строк
opt.cursorline = true -- Подсвечивать текущую строку
opt.wrap = false -- Отключить перенос строк по словам
opt.linebreak = true -- Переносить строки по словам, если wrap включен
opt.showmode = false -- Не показывать --INSERT-- и т.д. (lualine сделает лучше)
opt.signcolumn = "yes" -- Всегда показывать колонку знаков (для LSP, GitSigns)
opt.scrolloff = 8 -- Число строк контекста сверху/снизу при прокрутке
opt.sidescrolloff = 8 -- То же для горизонтальной прокрутки
--opt.colorcolumn = "80" -- Вертикальная линия на 80 символе (пример)

-- [[ Отступы ]]
opt.expandtab = true -- Использовать пробелы вместо табов
opt.tabstop = 4 -- Ширина таба = 4 пробела
opt.softtabstop = 4 -- Ширина таба при редактировании = 4 пробела
opt.shiftwidth = 4 -- Ширина отступа = 4 пробела
opt.autoindent = true -- Автоматический отступ для новых строк
opt.smartindent = true -- Более умный автоотступ

-- [[ Поиск ]]
opt.hlsearch = true -- Подсвечивать результаты поиска
opt.incsearch = true -- Показывать результаты поиска по мере ввода
opt.ignorecase = true -- Игнорировать регистр при поиске
opt.smartcase = true -- Учитывать регистр, если в запросе есть заглавные буквы

-- [[ Поведение Редактора ]]
opt.hidden = true -- Разрешить скрывать буферы без сохранения
opt.mouse = "a" -- Включить поддержку мыши во всех режимах
opt.splitright = true -- Новые вертикальные сплиты справа
opt.splitbelow = true -- Новые горизонтальные сплиты снизу
opt.completeopt = "menu,menuone,noselect" -- Опции автодополнения (для cmp)
opt.undofile = true -- Включить сохранение истории изменений
opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- Папка для истории изменений
pcall(vim.fn.mkdir, opt.undodir:get(), "p") -- Создать папку, если ее нет
opt.backup = false -- Не создавать бэкап файлы
opt.writebackup = false -- Не создавать бэкап перед записью
opt.swapfile = false -- Не использовать swap файлы (меньше мусора)
opt.updatetime = 300 -- Время (мс) до записи swap/undo и события CursorHold
opt.timeoutlen = 500 -- Время ожидания для <leader> и других маппингов (мс)
opt.confirm = true -- Спрашивать подтверждение, если есть несохраненные изменения (например, при :q)

-- [[ Глобальные переменные (если нужны) ]]
-- g.some_global_variable = "value"

print("Core options loaded.")
