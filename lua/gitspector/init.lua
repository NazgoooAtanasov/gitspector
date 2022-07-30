local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

M.gitspector = function ()
    local git_branches = vim.fn.systemlist("git branch -a")
    pickers.new({}, {
        prompt_title = "branches",
        finder = finders.new_table({
            results = git_branches
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selected_entry = action_state.get_selected_entry()
            local selection = selected_entry[1]

            vim.fn.systemlist(string.format("git checkout %s", selection))
          end)
          return true
        end,
    }):find()
end

return M
