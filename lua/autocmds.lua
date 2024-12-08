local api = vim.api

-- Highlight when yanking
api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- TODO: terminal enable "normal" mode by Esc

-- Jump to last postion v3  [source nvim issue 16339](https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370)
api.nvim_create_autocmd('BufRead', {
    callback = function(opts)
        api.nvim_create_autocmd('BufWinEnter', {
            once = true,
            buffer = opts.buf,
            callback = function()
                local ft = vim.bo[opts.buf].filetype
                local last_known_line = api.nvim_buf_get_mark(opts.buf, '"')[1]
                if
                    not (ft:match('commit') and ft:match('rebase') and ft:match('gitcommit') and ft:match('gitrebase'))
                    and last_known_line > 1
                    and last_known_line <= api.nvim_buf_line_count(opts.buf)
                then
                    api.nvim_feedkeys([[g`"]], 'nx', false)
                end
            end,
        })
    end,
})

-- Jump to last position v2
-- -- adapted from https://github.com/ethanholz/nvim-lastplace/blob/main/lua/nvim-lastplace/init.lua
-- local ignore_buftype = { "quickfix", "nofile", "help" }
-- local ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" }
--
-- local function run()
--   if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
--     return
--   end
--
--   if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
--     -- reset cursor to first line
--     vim.cmd[[normal! gg]]
--     return
--   end
--
--   -- If a line has already been specified on the command line, we are done
--   --   nvim file +num
--   if vim.fn.line(".") > 1 then
--     return
--   end
--
--   local last_line = vim.fn.line([['"]])
--   local buff_last_line = vim.fn.line("$")
--
--   -- If the last line is set and the less than the last line in the buffer
--   if last_line > 0 and last_line <= buff_last_line then
--     local win_last_line = vim.fn.line("w$")
--     local win_first_line = vim.fn.line("w0")
--     -- Check if the last line of the buffer is the same as the win
--     if win_last_line == buff_last_line then
--       -- Set line to last line edited
--       vim.cmd[[normal! g`"]]
--       -- Try to center
--     elseif buff_last_line - last_line > ((win_last_line - win_first_line) / 2) - 1 then
--       vim.cmd[[normal! g`"zz]]
--     else
--       vim.cmd[[normal! G'"<c-e>]]
--     end
--   end
-- end
--
-- api.nvim_create_autocmd({'BufWinEnter', 'FileType'}, {
--   group    = api.nvim_create_augroup('nvim-lastplace', {}),
--   callback = run
-- })
