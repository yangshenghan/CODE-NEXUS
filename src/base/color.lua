--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-18                                                    ]]--
--[[ License: zlib/libpng License                                           ]]--
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
nexus.base.color = {}

local function set_correct_value(value)
    if not value then return 0 end
    if value < 0 then return 0 end
    if value > 255 then return 255 end
    return value
end

function nexus.base.color.set(instance, ...)
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

function nexus.base.color.get(instance)
    return instance.red, instance.green, instance.blue, instance.alpha
end

function nexus.base.color.new(...)
    return nexus.base.color.set({}, ...)
end

