local map = vim.keymap.set

-- unfuck shit defaults
pcall(vim.keymap.del, "n", "gra")
pcall(vim.keymap.del, "n", "gri")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, "n", "grr")

map("i", "jk", "<Esc>", { silent = true })
map("n", "j", "gj", { silent = true })
map("n", "k", "gk", { silent = true })

map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

local fzf = require("fzf-lua")

map("n", "<leader><space>", fzf.files, {})
map("n", "<leader>/", fzf.grep, {})
map("n", "<leader>?", fzf.grep_last, {})
map("n", "<leader>ca", fzf.lsp_code_actions, {})
map("n", "<leader>cr", fzf.lsp_references, {})
map("n", "gd", fzf.lsp_definitions, { silent = true, noremap = true, nowait = true })
map("n", "gi", fzf.lsp_implementations, { silent = true, noremap = true, nowait = true })
map("n", "gr", fzf.lsp_references, { silent = true, noremap = true, nowait = true })
map("n", "<leader>cd", fzf.lsp_workspace_diagnostics, {})

-- windows
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
