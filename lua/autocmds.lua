local autocmd_grps = { "AutosaveGroup", "highlight", "folding" }
local vim = vim

--- Create autocmd groups
--- @groups - table with group names
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

--- Jump to last position v.3  [source nvim issue 16339](https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370)
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

--- Set folding methods  depending on whether nvim-treesitter has parsers and add `import` folding
local function set_foldingmethod()
    vim.api.nvim_create_autocmd({ "FileType" }, {
        group = "folding",
        -- enable = false ,
        callback = function()
            vim.defer_fn(function()
                if require("nvim-treesitter.parsers").has_parser() then
                    vim.wo.foldmethod = "expr"
                    -- vim.wo.foldexpr = "nvim_treesitter#foldexpr()" -- old way
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    -- vim.wo.foldexpr = "v:lnum==1?'>1':getline(v:lnum)=~'import'?1:nvim_treesitter#foldexpr()"
                else
                    vim.wo.foldmethod = "syntax"
                end
            end, 2000)



            -- local has_parser = pcall(function()
            --     return require("nvim-treesitter.parsers").has_parser()
            -- end) and require("nvim-treesitter.parsers").has_parser()
            --
            -- if has_parser then
            --     vim.wo.foldmethod = "expr"
            --     vim.wo.foldexpr   = "nvim_treesitter#foldexpr()"
            -- else
            --     vim.wo.foldmethod = "syntax"
            -- end
            --
            --
            -- disable folding on startup
            vim.opt.foldenable = false
            vim.opt.foldlevel = 20
        end,
    })
end


--- Save the current buffer if it was modified and meets all conditions.
---
--- Throttles saves so that disk writes occur at most once per `save_interval`
--- milliseconds, and adds an optional debounce delay after exiting insert mode.
---
--- @see vim.uv.now
--- @see vim.defer_fn
---
--- @param save_interval integer Minimum interval between saves, in ms.
--- @param exit_wait_time integer Debounce delay after InsertLeave, in ms.
--- @return nil
local function autosave(save_interval, exit_wait_time)
    --- @type integer
    local last_save_time = 0
    --- @type integer|nil
    local pending_timer = nil

    --- Check whether the buffer should be saved.
    --- @return boolean True if buffer is modifiable, modified, and not special.
    local function should_save()
        local ft = vim.bo.ft
        return not vim.bo.readonly
            and vim.api.nvim_buf_get_name(0) ~= ""
            and vim.bo.buftype == ""
            and vim.bo.modifiable
            and vim.bo.modified
            and not (ft:match('commit') and ft:match('rebase') and ft:match('gitcommit') and ft:match('gitrebase'))
    end

    --- Perform the actual save if enough time has elapsed.
    local function perform_save()
        if not should_save() then
            return
        end
        local now = vim.uv.now()
        if now - last_save_time >= save_interval then
            last_save_time = now
            vim.notify("autosave", vim.log.levels.INFO)
            vim.cmd("silent write")
            vim.cmd("doautocmd BufWritePost")
        end
    end

    -- Create augroup (cleared) and autocmds
    local group_id = vim.api.nvim_create_augroup("AutosaveGroup", { clear = true })

    -- Immediate on text change; throttled by interval
    vim.api.nvim_create_autocmd("TextChanged", {
        group = group_id,
        pattern = "*",
        callback = perform_save,
    })

    -- On exiting insert: debounce via vim.defer_fn
    vim.api.nvim_create_autocmd("InsertLeave", {
        group = group_id,
        pattern = "*",
        callback = function()
            if pending_timer then
                pending_timer:stop()
                pending_timer:close()
                pending_timer = nil
                set_foldingmethod()
            end
            pending_timer = vim.defer_fn(function()
                perform_save()
                pending_timer = nil
            end, exit_wait_time)
        end,
    })

    -- Cancel pending save if re-entering Insert mode
    vim.api.nvim_create_autocmd("InsertEnter", {
        group = group_id,
        pattern = "*",
        callback = function()
            if pending_timer then
                pending_timer:stop()
                pending_timer:close()
                pending_timer = nil
            end
        end,
    })
end

-- TODO: terminal enable "normal" mode by Esc



create_groups(autocmd_grps)
highlight_on_yank()
last_position()
set_foldingmethod()
autosave(10000, 5000)
