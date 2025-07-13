local map = vim.keymap.set

map("i", "jk", "<Esc>", { silent = true })
map("n", "j", "gj", { silent = true })
map("n", "k", "gk", { silent = true })

map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

local fzf = require("fzf-lua")

map("n", "<leader><space>", fzf.files, {} )
map("n", "<leader>/", fzf.grep, {} )
map("n", "<leader>?", fzf.grep_last, {} )
map("n", "ca", fzf.lsp_code_actions, {} )
map("n", "<leader>cr", fzf.lsp_references, {} )
map("n", "gd", fzf.lsp_definitions, {} )
map("n", "<leader>cd", fzf.lsp_workspace_diagnostics, {} )
