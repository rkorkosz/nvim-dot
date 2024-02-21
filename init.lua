vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.cmd.colorscheme "catppuccin"
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.g.mapleader = ','
vim.o.timeout = true
vim.o.timeoutlen = 300

require('nvim-tree').setup()
require('lualine').setup()
require('nvim-treesitter.configs').setup({
	ensure_installed = {"go", "gomod"},
	highlight = {
		enable = true
	}
})
require('telescope').setup({
	defaults = {
		layout_strategy = "vertical"
	},
})

require('gitsigns').setup()
local lspconfig = require('lspconfig')
lspconfig.gopls.setup({
	on_attach = require('lsp-format').on_attach,
})
lspconfig.ccls.setup({})

local builtin = require('telescope.builtin')

local cmp = require('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	})
})
local wk = require("which-key")
wk.setup()

wk.register({
	t = {
		name = "+telescope",
		t = { builtin.builtin, "Telescope pickers" },
		r = { builtin.resume, "Telescope resume" },
	},
	f = {
		name = "+file",
		f = { builtin.find_files, "Find File" },
		g = { builtin.live_grep, "Live Grep" },
		b = { builtin.buffers, "Find Buffer" },
		d = { builtin.diagnostics, "Diagnostics" },
	},
	g = {
		name = "+git",
		s = { builtin.git_status, "Git status" },
		t = { builtin.git_stash, "Git stash" },
	},
	c = {
		name = "+code",
		a = { vim.lsp.buf.code_action, "Code action" },
		r = { vim.lsp.buf.rename, "Rename" },
	},
	e = { ":NvimTreeOpen<CR>", "File explorer" },
}, { prefix = "<leader>" })

wk.register({
	g = {
		name = "+lsp",
		d = { builtin.lsp_definitions, "Go to definition" },
		i = { builtin.lsp_implementations, "Go to implementation" },
		r = { builtin.lsp_references, "Go to references" },
	},
})

wk.register({
	r = { vim.lsp.buf.rename, "Rename" },
	c = { vim.lsp.buf.code_action, "Code action" },
	f = { function()
		vim.lsp.buf.format({ async = true })
	end, "Format" },
}, { prefix = "<space>"})

