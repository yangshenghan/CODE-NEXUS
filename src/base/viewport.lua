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
local nexus                 = nexus

nexus.base.viewport         = {}

local require               = require
local Graphics              = require 'src.core.graphics'
local Rectangle             = require 'src.base.rectangle'

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

    Graphics.removeViewport(instance)
end

function nexus.base.viewport.disposed(instance)
    return instance.drawables == nil
end

function nexus.base.viewport.flash(instance, color, duration)
end

function nexus.base.viewport.update(instance, dt)
end

function nexus.base.viewport.render(instance)
    local u, v, w, h = Rectangle.get(instance.rectangle)
    table.sort(instance.drawables, drawable_zorder_sorter)

    love.graphics.push()
    love.graphics.translate(instance.ox, instance.oy)
    for _, drawable in pairs(instance.drawables) do
        if not drawable.disposed(drawable) and drawable.visible then
            local dx = drawable.x - u
            local dy = drawable.y - v
            if dx >= 0 and dx <= w and dy >= 0 and dy <= h then
                drawable.render(drawable)
            end
        end
    end
    love.graphics.pop()
end

function nexus.base.viewport.new(...)
    local instance = {}
    if ... == nil then
        instance.rectangle = Rectangle.new(0, 0, Graphics.getScreenWidth(), Graphics.getScreenHeight())
    elseif type(...) == 'table' then
        local args = ...
        instance.rectangle = args.rectangle or Rectangle.new(args.x or 0, args.y or 0, args.width or Graphics.getScreenWidth(), args.height or Graphics.getScreenHeight())
    else
        local x, y, width, height = unpack({...})
        instance.rectangle = Rectangle.new(x, y, width, height)
    end

    instance.z = 0
    instance.ox = 0
    instance.oy = 0
    instance.visible = true
    instance.drawables = {}

    Graphics.addViewport(instance)
    return instance
end
