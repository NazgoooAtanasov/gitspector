local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")

local M = {}

local search_or_create_branch = function (prompt_bufnr, map, branches_or_diff_error)
    actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selected_entry = action_state.get_selected_entry()

        if selected_entry then
            local selection = selected_entry[1]

            -- stashing eveyrhing before branch switching
            if branches_or_diff_error.diff ~= nil then
                vim.fn.systemlist("git stash save")
            end

            local git_checkout = string.format("git checkout %s", selection)
            vim.fn.systemlist(git_checkout)
        else
            local selection = action_state.get_current_line()
            local git_checkout = string.format("git checkout -b %s", selection)
            vim.fn.systemlist(git_checkout)
        end
    end)
end

local get_branches_or_diff_error = function ()
    local git_diff = vim.fn.systemlist("git diff")

    if not next(git_diff) then
        git_diff = nil
    end

    local branches_result = vim.fn.systemlist("git branch -a")

    return {
        branches_result = branches_result,
        diff = git_diff
    }
end

local render_branches_list = function (branches_or_diff_error)
    pickers.new({}, {
        prompt_title = "branches",
        finder = finders.new_table({
            results = branches_or_diff_error.branches_result
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function (prompt_bufnr, map)
            search_or_create_branch(prompt_bufnr, map, branches_or_diff_error)
            return true
        end,
    }):find()
end

M.branches_list = function ()
    local branches_or_diff_error = get_branches_or_diff_error()
    render_branches_list(branches_or_diff_error)
end

return M
