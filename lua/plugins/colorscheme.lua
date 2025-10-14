-- colorscheme builtins:
-- "blue", "darkblue", "default" "delek", "desert", "elflord" "evening", "habamax", "industry", "koehler", "lunaperche", "morning", "murphy", "pablo", "peachpuff","ron", "quiet", "retrobox", "shine", "slate", "sorbet", "torte", "unokai", "vim", "wildcharm", "zaibatsu" "zellner"

-- Blacklist-based filtered completion for :colorscheme
-- 1) Blacklist of built-in themes to disable
local blacklist = {
    "blue", "darkblue", "delek", "desert",
    "evening", "industry", "koehler", "morning",
    "murphy", "pablo", "peachpuff", "ron",
    "shine", "slate", "torte", "zellner",
    "quiet", "retrobox", "vim", "sorbet", "habamax",
    "unokai", "lunaperche", "wildcharm", "zaibatsu",

    "catppuccin-mocha", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-latter",
    "kanagawa-wave", "kanagawa-lotus",

}
local blocked = {}
for _, name in ipairs(blacklist) do blocked[name] = true end

-- 2) Lua completion function
--    It must accept (arg_lead, cmd_line, cursor_pos) but we only need arg_lead.
_G.complete_colorscheme = function(arg_lead, _, _)
    local all = vim.fn.getcompletion(arg_lead, "color")
    return vim.tbl_filter(function(name)
        return not blocked[name] and name:match("^" .. arg_lead)
    end, all)
end

-- 3) Define user command and abbreviation **after** builtins load
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- a) Create uppercase :Colorscheme with Lua completion
        vim.api.nvim_create_user_command("Colorscheme",
            function(ctx)
                vim.cmd("silent! colorscheme " .. ctx.args)
            end,
            {
                nargs    = 1,
                complete = _G.complete_colorscheme,
            }
        )

        -- b) Abbreviate lowercase to uppercase **without bypassing completion**
        --    This maps the full word only; pressing <Tab> after typing letters still invokes
        --    the Colorscheme command and its Lua completion.
        vim.cmd([[
      cnoreabbrev <expr> colorscheme
        \ getcmdtype() == ':' && getcmdline() ==# 'colorscheme'
        \ ? 'Colorscheme'
        \ : 'colorscheme'
    ]])
    end,
})

-- 4) Plugin list with your custom schemes
return {
    {
        "catppuccin/nvim",
        cond = true,
        lazy = false,
        name = "catppuccin",
        priority = 1000,
        --- activate
        config = function()
            vim.cmd.colorscheme "catppuccin-mocha"
        end
    },
    {
        "doums/darcula",
        cond = true,
        lazy = false,
        -- priority = 1000,
        name = "darcula",
    },
    {
        "folke/tokyonight.nvim",
        cond = false,
        lazy = false,
        -- priority = 1000,
        opts = {},
    },
    {
        "rebelot/kanagawa.nvim",
        cond = true,
        opts = {},
    },
    {
        "navarasu/onedark.nvim",
        cond = false,
        -- priority = 1000,
        opts = {},
    }
}
