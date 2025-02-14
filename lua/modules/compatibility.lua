-- Tools for improving compatibility with other plugins
local utils = require("modules.utils")
local M = {}

function M.treesitter_textobjects(init_key)
	local treesitter = utils.prequire("nvim-treesitter.configs")
	if treesitter then
		local select = treesitter.get_module("textobjects.select")
		if select then
			if not select.enable then
				print("Visual.nvim: treesitter-textobjects select is not enabled, have you enabled it?")
			else
				if select.keymaps then
					for key, query in pairs(select.keymaps) do
						local group
						if type(query) == "table" then
							query = query.query
							group = query.query_group
						else
							group = nil
						end
						local selection_mode = select.selection_modes[query] or "v"

						vim.keymap.set({ "n", "v" }, init_key .. key, function()
							require("nvim-treesitter.textobjects.select").select_textobject(
								query,
								group,
								selection_mode
							)
						end)
					end
				else
					print("Visual.nvim: treesitter-textobjects keymaps not found, have you set them up?")
				end
			end
		else
			print(
				"Visual.nvim: treesitter-textobjects selection is not available, have you installed nvim-treesitter-textobjects?"
			)
		end
	else
		print("Visual.nvim: treesitter enabled but not found, have you installed it? ")
	end
end

return M
