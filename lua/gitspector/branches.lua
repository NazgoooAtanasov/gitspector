local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")

local M = {}

local search_or_create_branch = function (prompt_bufnr, map)
    actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selected_entry = action_state.get_selected_entry()

        if selected_entry then
            local selection = selected_entry[1]
            local git_checkout = string.format("git checkout %s", selection)
            vim.fn.systemlist(git_checkout)
        else
            local selection = action_state.get_current_line()
            local git_checkout = string.format("git checkout -b %s", selection)
            vim.fn.systemlist(git_checkout)
        end
    end)

    return true
end

M.get_branches_or_diff_error = function ()
    -- check if there is any diff before returning all the branches, otherwise the checkout will fail
    return vim.fn.systemlist("git branch -a")
end

M.render_branches_list = function (branches_list)
    pickers.new({}, {
        prompt_title = "branches",
        finder = finders.new_table({
            results = branches_list
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = search_or_create_branch,
    }):find()
end

return M
