local util = require("java-method-search.util")

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local config = require("telescope.config")

local M = {}

local function create_entry_maker(java_methods_details)
    return function(entry)
        for _, java_method_details in pairs(java_methods_details) do
            if java_method_details.method_name == entry then
                return {
                    value = java_method_details,
                    display = java_method_details.method_name,
                    ordinal = java_method_details.method_name,
                    method_name = java_method_details.method_name,
                    method_text = java_method_details.method_text,
                    range = java_method_details.range,
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

function M.search()
    local java_methods = util.get_java_methods()
    local java_method_names = util.get_java_method_names(java_methods)

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
                    actions.close(prompt_bufnr)
                    local selected_java_method = action_state.get_selected_entry()
                    util.move_to_selected_java_method(selected_java_method)
                end)
                return true
            end,
        })
        :find()
end

return M
