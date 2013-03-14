--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-13                                                    ]]--
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
nexus.scene.loading = {}

local function enter(instance)
    instance.loading.progress = 0
    instance.loading.coroutine = coroutine.create(instance.loading.enter)
end

local function update(instance)
    coroutine.resume(instance.loading.coroutine, instance)

    if coroutine.status(instance.loading.coroutine) == 'dead' then
        -- local start = love.timer.getTime()
        -- while love.timer.getTime() - start < 1 do end
        instance.enter = instance.loading.enter
        instance.update = instance.loading.update
        instance.render = instance.loading.render
        instance.loading.routing = nil
    end
end

local function render(instance)
    love.graphics.print(instance.loading.progress, 240, 240)
end

function nexus.scene.loading.setProgress(instance, value)
    if value < 0 then
        value = 0
    end
    if value > 1 then
        value = 1
    end
    instance.loading.progress = value

    coroutine.yield()
end

function nexus.scene.loading.new(instance)
    instance.loading = {
        screen          = instance,
        enter           = instance.enter or function(...) end,
        update          = instance.update or function(...) end,
        render          = instance.render or function(...) end,
        progress        = 0
    }
    instance.enter = enter
    instance.update = update
    instance.render = render
    return nexus.scene.new(instance)
end