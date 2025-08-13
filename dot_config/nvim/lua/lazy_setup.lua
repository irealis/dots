local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "tpope/vim-fugitive" },
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			vim.cmd("colorscheme rose-pine")
		end
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			files = {
				fd_opts = [[--color=never --hidden --type f --type l --exclude .git --exclude .jj ]],
			}
		},

		config = function()
			require("fzf-lua").register_ui_select()
		end
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			formatters = {
				dotnetfmt = {
					command = "dotnet",
					args = { "format", "--include", "$FILENAME" },
					stdin = true,
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				html = { "prettier" },
				--csharp = { "dotnetfmt" },
			},
			format_after_save = {
				-- These options will be passed to conform.format()
				--timeout_ms = 500,
				lsp_format = "fallback",
				async = true,
			},
		},
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>oo", "<cmd>Oil<CR>" },
		},
	},
	{ "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" },
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },

				["<Tab>"] = { "select_next", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},
			completion = {
				menu = {
					auto_show = function(ctx)
						return ctx.mode ~= "cmdline" and not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
					end,
				},
				list = {
					selection = { preselect = false, auto_insert = true },
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			signature = { enabled = true },
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "snippets" },
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		'mfussenegger/nvim-dap',
		dependencies = {
			'rcarriga/nvim-dap-ui',
			'nvim-neotest/nvim-nio',
		},
		keys = function(_, keys)
			local dap = require 'dap'
			local dapui = require 'dapui'
			return {
				{ '<F5>',       dap.continue,          desc = 'Debug: Start/Continue' },
				{ '<F1>',       dap.step_into,         desc = 'Debug: Step Into' },
				{ '<F2>',       dap.step_over,         desc = 'Debug: Step Over' },
				{ '<F3>',       dap.step_out,          desc = 'Debug: Step Out' },
				{ '<leader>bb', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
				{
					'<leader>bc',
					function()
						dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
					end,
					desc = 'Debug: Set Breakpoint',
				},
				{ '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
				unpack(keys),
			}
		end,
		config = function()
			local dap = require 'dap'
			local dapui = require 'dapui'
			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
			}

			dap.adapters.coreclr = {
				type = 'executable',
				command = 'netcoredbg',
				args = { '--interpreter=vscode' }
			}

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/src/Web/bin/Debug/', 'file')
					end,
				},
			}

			local dap = require('dap')
			dap.adapters.firefox = {
				type = 'executable',
				command = 'node',
				args = { os.getenv('HOME') .. '/dev/vscode-firefox-debug/dist/adapter.bundle.js' },
			}

			dap.configurations.typescript = {
				{
					name = 'Attach Firefox',
					type = 'firefox',
					request = 'attach',
					reAttach = true,
					host = '127.0.0.1',
					url = 'http://localhost:4200',
					webRoot = '${workspaceFolder}',
				}
			}

			dapui.setup {
			}

			-- Change breakpoint icons
			vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
			vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
			local breakpoint_icons = {
				Breakpoint = '',
				BreakpointCondition = '',
				BreakpointRejected = '',
				LogPoint = '',
				Stopped = ''
			}
			for type, icon in pairs(breakpoint_icons) do
				local tp = 'Dap' .. type
				local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
				vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
			end

			dap.listeners.after.event_initialized['dapui_config'] = dapui.open
			dap.listeners.before.event_terminated['dapui_config'] = dapui.close
			dap.listeners.before.event_exited['dapui_config'] = dapui.close
		end,
	},
})
