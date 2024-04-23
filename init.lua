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
vim.o.undofile = true
vim.opt.mouse = ''

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

local gs = require('gitsigns')
gs.setup()
local lspconfig = require('lspconfig')
lspconfig.gopls.setup({
	settings = {
		gopls = {
			completeUnimported = true,
			gofumpt = true,
			staticcheck = true,
			codelenses = {
				gc_details = true,
				tidy = true,
				upgrade_dependency = true,
			},
			analyses = {
				fieldalignment = true,
				shadow = true,
				unusedvariable = true,
				unusedwrite = true,
			},
		},
	},
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
	h = {
		name = "+GitSigns",
		s = { gs.stage_hunk, "Stage hunk" },
		r = { gs.reset_hunk, "Reset hunk" },
		S = { gs.stage_buffer, "Stage buffer" },
		u = { gs.undo_stage_hunk, "Undo stage hunk" },
		R = { gs.reset_buffer, "Reset buffer" },
		p = { gs.preview_hunk, "Preview hunk" },
		b = { function() gs.blame_line{full=true} end, "Blame line" },
		B = { gs.toggle_current_line_blame, "Toggle line blame" },
		d = { gs.diffthis, "Diff" },
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
	h = {
		s = { function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "Stage hunk" },
		r = { function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "Reset hunk" },
	},
}, { mode = 'v', prefix = '<leader>' })

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

local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end
    end,
	sources = {
		null_ls.builtins.completion.spell,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.code_actions.gomodifytags,
	},
})
require("Comment").setup()
