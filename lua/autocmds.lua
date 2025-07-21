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
-- and add `import` folding
local function set_foldingmethod()
    vim.api.nvim_create_autocmd({ "FileType" }, {
        group = "folding",
        callback = function()
            if require("nvim-treesitter.parsers").has_parser() then
                vim.opt.foldmethod = "expr"
                -- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
                vim.opt.foldexpr = "v:lnum==1?'>1':getline(v:lnum)=~'import'?1:nvim_treesitter#foldexpr()"
            else
                vim.opt.foldmethod = "syntax"
            end
            -- disable folding on startup
            vim.opt.foldenable = false
            vim.opt.foldlevel = 20
        end,
    })
end

-- Autosave on exiting insert mode and text change like formatting
local function autosave()
    local last_save_time = 0
    local save_interval = 10000 -- 10 seconds in milliseconds
    local exit_wait_time = 5000 -- 05 seconds wait after InsertLeave
    local pending_timer = nil

    local function should_save()
        if vim.bo.readonly
            or vim.api.nvim_buf_get_name(0) == ''
            or vim.bo.buftype ~= ''
            or not (vim.bo.modifiable and vim.bo.modified)
        then
            return false
        end
        return true
    end

    local function perform_save()
        if not should_save() then
            return
        end

        local current_time = vim.uv.now()
        if current_time - last_save_time >= save_interval then
            last_save_time = current_time
            vim.notify("saving", vim.log.levels.INFO)
            vim.cmd('silent w')
            vim.cmd('doau BufWritePost')
        end
    end

    vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("saving", { clear = true }),
        pattern = "*",
        callback = function(args)
            if not should_save() then
                return
            end

            -- Cancel any pending timer
            if pending_timer then
                pending_timer:stop()
                pending_timer:close()
                pending_timer = nil
            end

            if args.event == "InsertLeave" then
                -- Wait 5 seconds after exiting insert mode
                pending_timer = vim.defer_fn(function()
                    perform_save()
                    pending_timer = nil
                end, exit_wait_time)
            else
                -- TextChanged - immediate check with interval throttling
                perform_save()
            end
        end
    })

    -- Cancel pending save if user re-enters insert mode
    vim.api.nvim_create_autocmd("InsertEnter", {
        group = vim.api.nvim_create_augroup("saving_cancel", { clear = true }),
        pattern = "*",
        callback = function()
            if pending_timer then
                pending_timer:stop()
                pending_timer:close()
                pending_timer = nil
            end
        end
    })
end

-- TODO: terminal enable "normal" mode by Esc



create_groups(autocmd_grps)
highlight_on_yank()
last_position()
set_foldingmethod()
autosave()
