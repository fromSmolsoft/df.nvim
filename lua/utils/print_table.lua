return {
    -- dump table to "pretty" string. Not suited for enormous tables (stack-overflow)
    dump = function(o)
        local seen = {}
        local function dump_recursive(obj, depth)
            depth = depth or 0
            if depth > 10 then
                return "[depth >=" .. depth .. "]"
            end
            if type(obj) == 'table' then
                if seen[obj] then
                    return "[circular reference]"
                end
                seen[obj] = true
                local indent = string.rep(" ", depth * 2)
                local s = '{'
                local key_formatted
                for k, v in pairs(obj) do
                    if type(k) == 'number' then
                        key_formatted = "[" .. tostring(k) .. "] = "
                    else
                        key_formatted = tostring(k) .. " = "
                    end
                    s = s .. "\n" .. indent .. key_formatted .. dump_recursive(v, depth + 1) .. ','
                end
                local closing_indent = string.rep(" ", (depth * 2) - 2 )
                return s .. "\n" .. closing_indent .. '}'
            else
                return tostring(obj)
            end
        end
        return dump_recursive(o)
    end,
}
