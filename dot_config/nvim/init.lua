vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("<cr>")

require("lazy_setup")
require("options")
require("lsp")
require("statusline")
require("keymaps")
--require("dap-config")
