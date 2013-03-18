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

nexus.scene.loading = {}

local function enter(instance)
    instance.progress = 0
    instance.coroutine = coroutine.create(instance.scene.enter)
    instance.scene.loading = instance

    instance.render(instance)
    love.graphics.present()
end

local function update(instance, dt)
    _, instance.progress = coroutine.resume(instance.coroutine, instance.scene, dt)

    if coroutine.status(instance.coroutine) == 'dead' then
        nexus.core.scene.change(instance.scene)
        instance.scene = nil
    end
end

local function render(instance)
    love.graphics.print(instance.progress, 240, 240)
end

function nexus.scene.loading.setProgress(value)
    if value < 0 then value = 0 end
    if value > 1 then value = 1 end
    coroutine.yield(value)
end

function nexus.scene.loading.new(instance)
    return nexus.base.scene.new({
        enter   = enter,
        update  = update,
        render  = render,
        scene   = nexus.base.scene.new(instance)
    })
end
