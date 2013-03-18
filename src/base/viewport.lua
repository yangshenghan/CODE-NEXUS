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

nexus.base.viewport = {}

function nexus.base.viewport.dispose(instance)
end

function nexus.base.viewport.isDisposed(instance)
end

function nexus.base.viewport.flash(instance, color, duration)
end

function nexus.base.viewport.update(instance)
end

function nexus.base.viewport.new(...)
    local instance = {}
    if ... == nil then
        instance.ox = 0
        instance.oy = 0
        instance.z = 0
        instance.rectangle = nexus.base.rectangle.new(0, 0, nexus.graphics.getScreenWidth(), nexus.graphics.getScreenHeight())
    elseif type(...) == 'table' then
        local args = ...
        instance.ox = args.ox or 0
        instance.oy = args.oy or 0
        instance.z = args.z or 0
        instance.rectangle = args.rectangle or nexus.base.rectangle.new(0, 0, nexus.graphics.getScreenWidth(), nexus.graphics.getScreenHeight())
    else
        local ox, oy, z, rectangle = unpack({...})
        instance.ox = ox
        instance.oy = oy
        instance.z = z
        instance.rectangle = rectangle
    end
    return instance
end
