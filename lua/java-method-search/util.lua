local M = {}

local function create_method_query()
    local java_method_query = [[
        (method_declaration) @method
    ]]

    return vim.treesitter.query.parse("java", java_method_query)
end

local function extract_method_details(bufnr, node)
    local method_name_node = node:field("name")[1]

    if not method_name_node then
        return nil
    end

    local method_name = vim.treesitter.get_node_text(method_name_node, bufnr)
    local start_line, _, end_line, _ = node:range()
    local method_text = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line + 1, false)

    return {
        method_name = method_name,
        range = { start_line, 0 },
        method_text = table.concat(method_text, "\n"),
    }
end

function M.get_java_methods()
    local bufnr = vim.api.nvim_get_current_buf()
    local tree = vim.treesitter.get_parser(bufnr, "java"):parse()[1]
    local ts_query = create_method_query()

    local java_methods = {}

    for id, node in ts_query:iter_captures(tree:root(), bufnr, 0, -1) do
        if ts_query.captures[id] == "method" then
            local method_details = extract_method_details(bufnr, node)
            if method_details then
                table.insert(java_methods, method_details)
            end
        end
    end

    return java_methods
end

function M.move_to_selected_test_method(selected_java_method)
    if selected_java_method then
        local range = selected_java_method.range
        vim.api.nvim_win_set_cursor(0, { range[1] + 1, range[2] })
        vim.cmd("normal! zz")
    end
end

function M.get_java_method_names(java_methods_details)
    local java_method_names = {}

    for _, java_method_details in ipairs(java_methods_details) do
        table.insert(java_method_names, java_method_details.method_name)
    end

    return java_method_names
end

return M
