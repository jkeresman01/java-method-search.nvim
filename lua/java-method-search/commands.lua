local java_methods = require("java-method-search.java_method")

local M = {}

function M.register()
    vim.api.nvim_create_user_command("JavaMethodSearch", function()
        java_methods.search()
    end, {
        desc = "Run Java method search",
    })
end

return M
