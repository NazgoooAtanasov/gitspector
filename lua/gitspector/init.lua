local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

M.gitspector = function ()
    pickers.new({}, {
        prompt_title = "branches",
        finder = finders.new_table({
            results = { "red", "green", "blue" }
        }),
        sorter = conf.generic_sorter({}),
        attatch_mappings = function(prompt_bufnr, map)
            actions.select_default:repalce(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.api.nvim_put({ selection[1] }, "", false, true)
            end)
            return true
        end
    }):find()
end

return M
