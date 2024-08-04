local util = require("java-method-search.util")

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local config = require("telescope.config")

local M = {}

function M.search()
    local results = util.get_java_methods()

    local items = {}
    for _, result in ipairs(results) do
        table.insert(items, result.method_name)
    end

    pickers
        .new({}, {
            prompt_title = "Java Methods",

            finder = finders.new_table({
                results = items,

                entry_maker = function(entry)
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
                end,
            }),

            sorter = config.values.generic_sorter({}),

            previewer = previewers.new_buffer_previewer({
                define_preview = function(self, entry)
                    local bufnr = self.state.bufnr
                    vim.api.nvim_buf_set_lines(
                        bufnr,
                        0,
                        -1,
                        false,
                        vim.split(entry.method_text, "\n")
                    )
                    vim.api.nvim_buf_set_option(bufnr, "filetype", "java")
                end,
            }),

            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    if selection then
                        local range = selection.range
                        vim.api.nvim_win_set_cursor(0, { range[1] + 1, range[2] })
                        vim.cmd("normal! zz")
                    end
                end)

                return true
            end,
        })
        :find()
end

return M
