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
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Rectangle             = {
    x                       = 0,
    y                       = 0,
    width                   = 0,
    height                  = 0
}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Rectangle.new(...)
    local instance = setmetatable({}, { __index = Rectangle })
    instance.set(instance, ...)
    return instance
end

function Rectangle.get(instance)
    return instance.x, instance.y, instance.width, instance.height
end

function Rectangle.set(instance, ...)
    if ... == nil then
        instance.empty(instance)
    elseif type(...) == 'table' then
        local xywh = ...
        instance.x = xywh.x or xywh[1] or instance.x
        instance.y = xywh.y or xywh[2] or instance.y
        instance.width = xywh.width or xywh[3] or instance.width
        instance.height = xywh.height or xywh[4] or instance.height
    else
        local x, y, width, height = ...
        instance.x = x or instance.x
        instance.y = y or instance.y
        instance.width = width or instance.width
        instance.height = height or instance.height
    end
    return instance
end

function Rectangle.empty(instance)
    instance.x = 0
    instance.y = 0
    instance.width = 0
    instance.height = 0
end

return Rectangle
