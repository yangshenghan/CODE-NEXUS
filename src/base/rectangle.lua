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
local nexus = nexus

nexus.base.rectangle = {}

function nexus.base.rectangle.empty(instance)
    instance.x = 0
    instance.y = 0
    instance.width = 0
    instance.height = 0
end

function nexus.base.rectangle.set(instance, ...)
    if ... == nil then
        nexus.base.rectangle.empty(instance)
    elseif type(...) == 'table' then
        local xywh = ...
        instance.x = xywh.x or xywh[1] or 0
        instance.y = xywh.y or xywh[2] or 0
        instance.width = xywh.width or xywh[3] or 0
        instance.height = xywh.height or xywh[4] or 0
    else
        local x, y, width, height = unpack({...})
        instance.x = x
        instance.y = y
        instance.width = width
        instance.height = height
    end
    return instance
end

function nexus.base.rectangle.get(instance)
    return instance.x, instance.y, instance.width, instance.height
end

function nexus.base.rectangle.new(...)
    return nexus.base.rectangle.set({}, ...)
end
