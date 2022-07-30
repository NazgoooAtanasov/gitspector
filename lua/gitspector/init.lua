local branches = require("gitspector.branches")

local M = {}

M.branches_list = function ()
    branches.render_branches_list(branches.get_branches_or_diff_error())
end

return M
