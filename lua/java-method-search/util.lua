local M = {}

local function create_method_query()
    local query = [[
        (method_declaration) @method
    ]]
    return vim.treesitter.query.parse("java", query)
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

    local results = {}
    for id, node in ts_query:iter_captures(tree:root(), bufnr, 0, -1) do
        if ts_query.captures[id] == "method" then
            local method_details = extract_method_details(bufnr, node)
            if method_details then
                table.insert(results, method_details)
            end
        end
    end

    return results
end

return M
