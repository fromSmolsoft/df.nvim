local api = vim.api

-- Highlight when yanking
api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

local group = vim.api.nvim_create_augroup("jump_last_position", { clear = true })

-- FIXME:Throws `while processing BufReadCmd Autocommands for "fugitive://*"....Cursor position outside buffer...`
vim.api.nvim_create_autocmd(
    "BufReadPost",
    {
        callback = function()
            local row, col = unpack(vim.api.nvim_buf_get_mark(0, "\""))
            if { row, col } ~= { 0, 0 } then
                vim.api.nvim_win_set_cursor(0, { row, 0 })
            end
        end,
        group = group
    }
)
-- TODO: terminal enable "normal" mode by Esc
