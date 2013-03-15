--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-15                                                    ]]--
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
nexus.window.base = {}

local default = {
    update      = function(...) end,
    render      = function(...) end,
    active      = true,
    height      = nil,
    openness    = 1,
    padding     = 12,
    visible     = true,
    width       = nil,
    x           = nil,
    y           = nil,
    z           = 1000
}

function nexus.window.base.new(instance)
    for k, v in pairs(default) do
        if instance[k] == nil then
            instance[k] = v
        end
    end
    return instance
end

function nexus.window.base.dispose(instance)
    nexus.manager.window.removeWindow(instance)
end

function nexus.window.base.update(instance, dt, ...)
    if instance.active then
        return instance.update(instance, dt, ...)
    end
    return true
end

function nexus.window.base.render(instance, ...)
    if instance.visible then
        instance.render(instance, ...)
    end
end
