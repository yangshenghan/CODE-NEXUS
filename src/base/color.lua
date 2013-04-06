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
local math                  = math

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Color                 = {
    red                     = 0,
    green                   = 0,
    blue                    = 0,
    alpha                   = 0
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function set_correct_value(value)
    return math.clamp(0, value, 255)
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Color.new(...)
    local instance = setmetatable({}, { __index = Color })
    instance.set(instance, ...)
    return instance
end

function Color.get(instance)
    return instance.red, instance.green, instance.blue, instance.alpha
end

function Color.set(instance, ...)
    if type(...) == 'table' then
        local rgba = ...
        instance.red = set_correct_value(rgba.red or rgba[1])
        instance.green = set_correct_value(rgba.green or rgba[2])
        instance.blue = set_correct_value(rgba.blue or rgba[3])
        instance.alpha = set_correct_value(rgba.alpha or rgba[4])
    else
        local red, green, blue, alpha = unpack({...})
        instance.red = set_correct_value(red)
        instance.green = set_correct_value(green)
        instance.blue = set_correct_value(blue)
        instance.alpha = set_correct_value(alpha)
    end
    return instance
end

return Color
