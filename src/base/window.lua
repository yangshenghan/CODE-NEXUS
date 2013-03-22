--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-22                                                    ]]--
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

nexus.base.window = {}

local t_default = {
    create      = function(...) end,
    delete      = function(...) end,
    update      = function(...) end,
    render      = function(...) end,
    active      = false,
    height      = nil,
    openness    = 1,
    padding     = 12,
    visible     = false,
    width       = nil,
    x           = nil,
    y           = nil,
    z           = 1000
}

function nexus.base.window.dispose(instance)
    nexus.base.viewport.removeDrawable(nexus.core.graphics.getWindowViewport(), instance)
end

function nexus.base.window.update(instance, dt, ...)
    if instance.active then
        return instance.update(instance, dt, ...)
    end
    return true
end

function nexus.base.window.render(instance, ...)
    if instance.visible then
        instance.render(instance, ...)
    end
end

function nexus.base.window.open(instance)
    instance.active = true
    instance.visible = true
end

function nexus.base.window.close(instance)
    instance.active = false
    instance.visible = false
end

function nexus.base.window.new(instance)
    instance = table.merge(t_default, instance)
    instance.create(instance)
    nexus.base.viewport.addDrawable(nexus.core.graphics.getWindowViewport(), instance)
    return instance
end
