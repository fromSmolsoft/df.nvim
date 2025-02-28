local autocmd_grps = { "saving", "highlight", "folding" }
local vim = vim

-- create autocmd groups
-- @groups - table with group names
local function create_groups(groups)
    for _, value in ipairs(groups) do
        vim.api.nvim_create_augroup(value, { clear = false })
    end
end

-- Highlight when yanking
local function highlight_on_yank()
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = "highlight",
        callback = function()
            vim.highlight.on_yank({ timeout = 200 })
        end,
    })
end

-- Jump to last position v.3  [source nvim issue 16339](https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370)
local function last_position()
    vim.api.nvim_create_autocmd('BufRead', {
        callback = function(opts)
            vim.api.nvim_create_autocmd('BufWinEnter', {
                once = true,
                buffer = opts.buf,
                callback = function()
                    local ft = vim.bo[opts.buf].filetype
                    local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
                    if
                        not (ft:match('commit') and ft:match('rebase') and ft:match('gitcommit') and ft:match('gitrebase'))
                        and last_known_line > 1
                        and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
                    then
                        vim.api.nvim_feedkeys([[g`"]], 'nx', false)
                    end
                end,
            })
        end,
    })
end

-- set folding methods  depending on whether nvim-treesitter has parsers
local function set_foldingmethod()
    vim.api.nvim_create_autocmd({ "FileType" }, {
        group = "folding",
        callback = function()
            if require("nvim-treesitter.parsers").has_parser() then
                vim.opt.foldmethod = "expr"
                vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            else
                vim.opt.foldmethod = "syntax"
            end
            -- disable folding on startup
            vim.opt.foldenable = false
        end,
    })
end

-- Autosave on exiting insert mode and text change like formatting
local function autosave()
    vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
        group = "saving",
        pattern = "*",
        callback = function()
            if
                vim.bo.readonly
                or vim.api.nvim_buf_get_name(0) == ''
                or vim.bo.buftype ~= ''
                or not (vim.bo.modifiable and vim.bo.modified)
            then
                return
            end
            vim.notify("saving", vim.log.levels.INFO)
            vim.cmd('silent w')
            vim.cmd('doau BufWritePost')
        end

    })
end

-- TODO: terminal enable "normal" mode by Esc



create_groups(autocmd_grps)
highlight_on_yank()
last_position()
set_foldingmethod()
autosave()
