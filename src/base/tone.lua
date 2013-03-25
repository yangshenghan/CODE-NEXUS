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
local Tone                  = {
    red                     = 0,
    green                   = 0,
    blue                    = 0,
    gray                    = 0
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function set_correct_value(value, gray)
    if not value then return 0 end
    if gray and value < 0 then return 0 end
    if value > 255 then return 255 end
    if value < -255 then return -255 end
    return value
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Tone.new(...)
    local instance = setmetatable({}, { __index = Tone })
    instance.set(instance, ...)
    return instance
end

function Tone.get(instance)
    return instance.red, instance.green, instance.blue, instance.gray
end

function Tone.set(instance, ...)
    if type(...) == 'table' then
        local rgbg = ...
        instance.red = set_correct_value(rgba.red or rgbg[1])
        instance.green = set_correct_value(rgba.green or rgbg[2])
        instance.blue = set_correct_value(rgba.blue or rgbg[3])
        instance.gray = set_correct_value(rgba.gray or rgbg[4], true)
    else
        local red, green, blue, gray = unpack({...})
        instance.red = set_correct_value(red)
        instance.green = set_correct_value(green)
        instance.blue = set_correct_value(blue)
        instance.gray = set_correct_value(gray, true)
    end
    return instance
end

return Tone
