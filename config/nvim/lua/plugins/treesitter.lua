return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.setup()

			-- Install missing parsers
			local ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"rust",
				"go",
				"git_config",
				"gitcommit",
				"git_rebase",
				"gitignore",
				"gitattributes",
				"json5",
				"php",
			}
			local installed = ts.get_installed()
			local to_install = {}
			for _, lang in ipairs(ensure_installed) do
				if not vim.tbl_contains(installed, lang) then
					table.insert(to_install, lang)
				end
			end
			if #to_install > 0 then
				ts.install(to_install)
			end

			-- Enable treesitter highlighting automatically for filetypes
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					-- Only start for filetypes that have an installed parser
					local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype) or vim.bo[args.buf].filetype
					if vim.tbl_contains(ts.get_installed(), lang) then
						pcall(vim.treesitter.start, args.buf, lang)
					end
				end,
			})
		end,
	},
}
