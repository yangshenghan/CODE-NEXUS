--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Copyright (c) 2012-2013 CODE NEXUS Development Team                    ]]--
--[[                                                                        ]]--
--[[ This software is provided 'as-is', without any express or implied      ]]--
--[[ warranty. In no event will the authors be held liable for any damages  ]]--
--[[ arising from the use of this software.                                 ]]--
--[[                                                                        ]]--
--[[ Permission is granted to anyone to use this software for any purpose,  ]]--
--[[ including commercial applications, and to alter it and redistribute it ]]--
--[[ freely, subject to the following restrictions:                         ]]--
--[[                                                                        ]]--
--[[ 1. The origin of this software must not be misrepresented; you must not]]--
--[[    claim that you wrote the original software. If you use this software]]--
--[[    in a product, an acknowledgment in the product documentation would  ]]--
--[[    be appreciated but is not required.                                 ]]--
--[[                                                                        ]]--
--[[ 2. Altered source versions must be plainly marked as such, and must not]]--
--[[    be misrepresented as being the original software.                   ]]--
--[[                                                                        ]]--
--[[ 3. This notice may not be removed or altered from any source           ]]--
--[[    distribution.                                                       ]]--
--[[ ********************************************************************** ]]--

-- / ---------------------------------------------------------------------- \ --
-- | Import modules                                                         | --
-- \ ---------------------------------------------------------------------- / --
local type                  = type
local pairs                 = pairs
local error                 = error
local table                 = table
local tostring              = tostring
local coroutine             = coroutine
local setmetatable          = setmetatable
local getmetatable          = getmetatable

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local f_coroutine_resume    = coroutine.resume

-- / ---------------------------------------------------------------------- \ --
-- | Extend bulit-in lua modules and functions                              | --
-- \ ---------------------------------------------------------------------- / --
function table.first(t)
    return t[1]
end

function table.last(t)
    return t[#t]
end

function table.clone(t, m)
    local u = {}

    if m then
        setmetatable(u, m)
    else
        setmetatable(u, getmetatable(t))
    end

    for key, value in pairs(t) do
        if type(value) == 'table' then
            u[key] = table.clone(value)
        else
            u[key] = value
        end
    end
    return u
end

function table.merge(t, s)
    local r = table.clone(t)

    for key, value in pairs(s) do
        r[key] = value
    end

    return r
end

function table.indexOf(t, v)
    for key, value in pairs(t) do
        if type(v) == 'function' then
            if v(value) then return key end
        else
            if value == v then return key end
        end
    end

    return nil
end

function table.removeValue(t, v)
    local index = table.indexOf(t, v)
    if index then table.remove(t, index) end
    return t
end

function coroutine.resume(...)
    local success, result = f_coroutine_resume(...)
    if not success then error(tostring(result), 2) end
    return success, result
end
