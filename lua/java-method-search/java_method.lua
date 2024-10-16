local util = require("java-method-search.util")

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local config = require("telescope.config")

local M = {}

-- Helper function to retrieve and prepare Java method names for display
local function get_java_method_names(results)
    local items = {}
    for _, result in ipairs(results) do
        table.insert(items, result.method_name)
    end
    return items
end

local function create_entry_maker(results)
    return function(entry)
        for _, result in ipairs(results) do
            if result.method_name == entry then
                return {
                    value = result,
                    display = result.method_name,
                    ordinal = result.method_name,
                    method_name = result.method_name,
                    method_text = result.method_text,
                    range = result.range,
                }
            end
        end
    end
end

local function define_preview(self, entry)
    local bufnr = self.state.bufnr

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(entry.method_text, "\n"))
    vim.api.nvim_buf_set_option(bufnr, "filetype", "java")
end

local function on_select_method(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()

    if selection then
        local range = selection.range
        vim.api.nvim_win_set_cursor(0, { range[1] + 1, range[2] })
        vim.cmd("normal! zz")
    end
end

function M.search()
    local java_methods = util.get_java_methods()
    local java_method_names = get_java_method_names(java_methods)

    pickers
        .new({}, {
            prompt_title = "Java Methods",

            finder = finders.new_table({
                java_methods = java_method_names,
                entry_maker = create_entry_maker(java_methods),
            }),

            sorter = config.values.generic_sorter({}),

            previewer = previewers.new_buffer_previewer({
                define_preview = define_preview,
            }),

            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    on_select_method(prompt_bufnr)
                end)
                return true
            end,
        })
        :find()
end

return M
