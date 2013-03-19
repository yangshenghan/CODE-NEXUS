--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-19                                                    ]]--
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

local function drawable_zorder_sorter(a, b)
    return a.z < b.z
end

function nexus.base.viewport.addDrawable(instance, drawable)
    table.insert(instance.drawables, drawable)
end

function nexus.base.viewport.removeDrawable(instance, drawable)
    table.removeValue(instance.drawables, drawable)
end

function nexus.base.viewport.dispose(instance)
    instance.drawables = nil

    nexus.core.graphics.removeViewport(instance)
end

function nexus.base.viewport.isDisposed(instance)
    return instance.drawables == nil
end

function nexus.base.viewport.flash(instance, color, duration)
end

function nexus.base.viewport.update(instance, dt)
end

function nexus.base.viewport.render(instance)
    table.sort(instance.drawables, drawable_zorder_sorter)

    love.graphics.push()
    love.graphics.translate(instance.ox, instance.oy)
    for _, drawable in pairs(instance.drawables) do
        drawable.render(drawable)
    end
    love.graphics.pop()
end

function nexus.base.viewport.new(...)
    local instance = {}
    if ... == nil then
        instance.ox = 0
        instance.oy = 0
        instance.z = 0
        instance.rectangle = nexus.base.rectangle.new(0, 0, nexus.core.graphics.getScreenWidth(), nexus.core.graphics.getScreenHeight())
    elseif type(...) == 'table' then
        local args = ...
        instance.ox = args.ox or 0
        instance.oy = args.oy or 0
        instance.z = args.z or 0
        instance.rectangle = args.rectangle or nexus.base.rectangle.new(0, 0, nexus.core.graphics.getScreenWidth(), nexus.core.graphics.getScreenHeight())
    else
        local ox, oy, z, rectangle = unpack({...})
        instance.ox = ox or 0
        instance.oy = oy or 0
        instance.z = z or 0
        instance.rectangle = rectangle or nexus.base.rectangle.new(0, 0, nexus.core.graphics.getScreenWidth(), nexus.core.graphics.getScreenHeight())
    end

    instance.drawables = {}

    nexus.core.graphics.addViewport(instance)
    return instance
end
