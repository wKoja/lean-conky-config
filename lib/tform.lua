-- defend Lua version incompatibility, just in case
local _load = load
if _VERSION <= "Lua 5.1" then
    _load = loadstring
end

local tform = {}
T_ = tform -- T_: global alias for `tform`

-- scale a number
function tform.sc(num, scale)
    scale = scale or lcc.config.scale
    return num * scale
end

-- scale then round, for where only integers are allowed
function tform.sr(num, scale)
    return math.floor(tform.sc(num, scale) + 0.5)
end

-- scale then round to a multiple of 0.5
-- might be useful for certain cases, e.g. font size
function tform.sh(num, scale)
    return math.floor(tform.sc(num * 2, scale) + 0.5) / 2.0
end

-- apply transform functions to rewrite values in a string
-- e.g. "$sc{42}" would be replaced by the value of T_.sc(42)
setmetatable(tform, { __call = function(_, s)
    return s:gsub("$([%w_]+)(%b{})", function(f, args)
        return assert(_load("return T_." .. f .. "(" .. args:sub(2, -2) .. ")"))()
    end)
end })

return tform
