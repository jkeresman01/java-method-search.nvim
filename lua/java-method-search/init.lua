local M = {}

local function get_methods()

    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr, "java")
    local tree = parser:parse()[1]

    local query = [[
        (method_declaration) @method
    ]]

    local results = {}
    local ts_query = vim.treesitter.query.parse("java", query)

    for id, node in ts_query:iter_captures(tree:root(), bufnr, 0, -1) do
        if ts_query.captures[id] == "method" then
            local method_name_node = node:field("name")[1]

            if method_name_node then
                local method_name = vim.treesitter.get_node_text(method_name_node, bufnr)
                local start_line, _, end_line, _ = node:range()
                local method_text = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line + 1, false)

                table.insert(results, { method_name = method_name,
                                        range = {start_line, 0},
                                        method_text = table.concat(method_text, "\n") })
            end
        end
    end

    return results
end

function M.search()
    local results = get_methods()

    local items = {}
    for _, result in ipairs(results) do
        table.insert(items, result.method_name)
    end

    require('telescope.pickers').new({}, {
        prompt_title = 'Java Methods',

        finder = require('telescope.finders').new_table {
            results = items,
            entry_maker = function(entry)
                for _, result in ipairs(results) do
                    if result.method_name == entry then
                        return {
                            value       = result,
                            display     = result.method_name,
                            ordinal     = result.method_name,
                            method_name = result.method_name,
                            method_text = result.method_text,
                            range       = result.range,
                        }
                    end
                end
            end,
        },

        sorter = require('telescope.config').values.generic_sorter({}),

        previewer = require('telescope.previewers').new_buffer_previewer({
            define_preview = function(self, entry)
                local bufnr = self.state.bufnr

                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(entry.method_text, "\n"))
                vim.api.nvim_buf_set_option(bufnr, "filetype", "java")
            end,
        }),

        attach_mappings = function(prompt_bufnr, map)
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')

            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection then
                    local range = selection.range
                    vim.api.nvim_win_set_cursor(0, {range[1] + 1, range[2]})
                    vim.cmd('normal! zz')
                end
            end)

            return true
        end,
    }):find()
end

return M

