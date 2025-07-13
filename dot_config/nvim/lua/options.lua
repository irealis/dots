local o = vim.opt
local a = vim.api

o.cursorline = true
o.cursorlineopt = "screenline"
o.cursorcolumn = true
o.signcolumn = "yes"

o.number = true
o.wrap = false

o.scrolloff = 10
o.undofile = true

o.backup = false
o.writebackup = false

o.ignorecase = true
o.smartcase = true
o.hlsearch = false

o.inccommand = "split"

o.autoindent = true
o.copyindent = true
o.breakindent = true

o.tabstop = 4
o.shiftwidth = 4

o.spelllang = "en_us"
o.spell = true

o.updatetime = 500
o.timeoutlen = 300

-- Popup height
o.pumheight = 5

-- remove netrw banner for cleaner looking
vim.g.netrw_banner = 0

vim.g.have_nerd_font = true

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

local highlight_group = a.nvim_create_augroup("YankHighlight", { clear = true })
a.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

for _, plugin in pairs({
    "netrwFileHandlers",
    "2html_plugin",
    "spellfile_plugin",
    "matchit"
}) do
    vim.g["loaded_" .. plugin] = 1
end

o.completeopt = "menu,menuone,popup,fuzzy" -- modern completion menu

o.foldenable = true   -- enable fold
o.foldlevel = 99      -- start editing with all folds opened
o.foldmethod = "expr" -- use tree-sitter for folding method
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
