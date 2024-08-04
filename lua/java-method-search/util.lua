local M = {}

function M.get_java_methods()
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr, "java")
    local tree = parser:parse()[1]

    local query = [[
        (method_declaration) @method
    ]]

    local ts_query = vim.treesitter.query.parse("java", query)

    local results = {}
    for id, node in ts_query:iter_captures(tree:root(), bufnr, 0, -1) do
        if ts_query.captures[id] == "method" then
            local method_name_node = node:field("name")[1]

            if method_name_node then
                local method_name = vim.treesitter.get_node_text(method_name_node, bufnr)
                local start_line, _, end_line, _ = node:range()
                local method_text =
                    vim.api.nvim_buf_get_lines(bufnr, start_line, end_line + 1, false)

                table.insert(
                    results,
                    {
                        method_name = method_name,
                        range = { start_line, 0 },
                        method_text = table.concat(method_text, "\n"),
                    }
                )
            end
        end
    end

    return results
end

return M
