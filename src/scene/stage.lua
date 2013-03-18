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
nexus.scene.stage = {}

local function enter(instance)
    -- Load stage data
    instance.map = nexus.core.database.loadMapData(instance.name)
    instance.stage = nexus.core.database.loadStageData(instance.name)
    instance.script = nexus.core.database.loadScriptData(instance.name)

    -- Initialize stage
    instance.player = nexus.object.player.new()
    instance.objects = { instance.player }

    -- Create objects
    for _, data in pairs(instance.stage.objects) do
        local object = {}
        object = data
        object.update = data.update or function(...) end
        object.render = data.render or function(...) end
        table.insert(instance.objects, object)
    end

    -- love.graphics.setBackgroundColor(104, 136, 248)
end

local function leave(instance)
    instance.player.delete(instance.player)

    instance.objects = nil
    instance.player = nil
    instance.script = nil
    instance.stage = nil
    instance.map = nil
end

local function update(instance, dt)
    if instance.idle then return end

    if nexus.core.input.isKeyDown(NEXUS_KEY.Z) then
        nexus.object.player.rush(instance.player)
    end

    if nexus.core.input.isKeyDown(NEXUS_KEY.X) then
        nexus.object.player.jump(instance.player)
    end

    if nexus.core.input.isKeyDown(NEXUS_KEY.C) then
        nexus.object.player.attack(instance.player)
    end

    if nexus.core.input.isKeyDown(NEXUS_KEY.LEFT) and nexus.base.object.isPassable(instance.player, instance.player.object.x - 1, instance.player.object.y) then
        nexus.object.player.left(instance.player)
    end

    if nexus.core.input.isKeyDown(NEXUS_KEY.RIGHT) and nexus.base.object.isPassable(instance.player, instance.player.object.x + 1, instance.player.object.y) then
        nexus.object.player.right(instance.player)
    end

    if nexus.core.input.isKeyDown(NEXUS_KEY.UP) and nexus.base.object.isPassable(instance.player, instance.player.object.x, instance.player.object.y + 1) then
        nexus.object.player.up(instance.player)
    end

    if nexus.core.input.isKeyDown(NEXUS_KEY.DOWN) and nexus.base.object.isPassable(instance.player, instance.player.object.x, instance.player.object.y - 1) then
        nexus.object.player.down(instance.player)
    end

    -- instance.player.update(instance.player, dt)
    for _, object in pairs(instance.objects) do
        object.update(object, dt)
    end
end

local function render(instance)
    -- Draw basic grid for easy developing
    for j = 0, 45 do
        for i = 0, 80 do
            love.graphics.setColor(255, 255, 255, 32)
            love.graphics.rectangle('line', 16 * i, 16 * j, 16, 16)
        end
    end

    for _, object in pairs(instance.objects) do
        object.render(object)
    end
end

function nexus.scene.stage.getCurrentStage()
    local scene = nexus.core.scene.getCurrentScene()
    return scene.stage
end

function nexus.scene.stage.new(name)
    local instance = {
        enter   = enter,
        leave   = leave,
        update  = update,
        render  = render,
        name    = name
    }

    return nexus.scene.loading.new(instance)
end

