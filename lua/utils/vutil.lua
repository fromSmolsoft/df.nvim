--[[Collection of util specifically for Neovim.
[!] may depend on (Neo)vim   api
]]
return {

    --[[
    Get current operation system as a string.
    @returns string either "mac","win" or "linux"
    --]]
    get_os = function()
        local os_name = vim.fn.has("macunix") == 1 and "mac" or
            vim.fn.has("win32") == 1 and "win" or
            "linux"
        return os_name
    end,

    --[[
    Fetch user home folder.
    @returns string path to user home directory
    --]]
    get_userhome = function()
        return os.getenv("HOME")
    end,


    --[[
    Verify whether file exists and can be open for reading.
    Opens file for reading temporarily.
    @filename string
    @returns true if file exists, false if file doesn't exists or can't be open for reading
    --]]
    is_file = function(filename)
        local file = io.open(filename, "r")
        if file ~= nill then
            io.close(file)
            return true
        else
            return false
        end
    end,
}
