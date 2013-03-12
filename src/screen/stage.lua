--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-12                                                    ]]--
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
nexus.screen.stage = {
    stages  = {}
}

local gravity = 9.81;

local player = nil

local function begin_contact(a, b, collision)
end

local function end_contact(a, b, collision)
end

local function pre_solve(a, b, collision)
end

local function post_solve(a, b, collision)
end

local function enter(instance)
    instance.world = love.physics.newWorld(0, gravity * love.physics.getMeter(), true)
    instance.objects = nexus.manager.object.getObjects()

    instance.world:setCallbacks(begin_contact, end_contact, pre_solve, post_solve)

    player = nexus.object.player.new(instance.world)

    for _, data in pairs(instance.stage.objects) do
        local object = {}
        object.body = love.physics.newBody(instance.world, data.x, data.y, data.bodyType or 'static')
        object.shape = love.physics.newRectangleShape(data.width, data.height)
        object.fixture = love.physics.newFixture(object.body, object.shape, data.density or 0)
        object.draw = data.draw or function(...) end
        object.update = data.update or function(...) end
        nexus.manager.object.attachObject(object)
    end

    love.graphics.setBackgroundColor(104, 136, 248)
end

local function leave(instance)
    player.delete(player)

    instance.world = nil
    player = nil
end

local function update(instance, dt)
    if instance.idle then return end

    instance.world.update(instance.world, dt)

    if nexus.input.isKeyDown(NEXUS_KEY.Z) then
        nexus.console.showDebugMessage('Player rush')
        nexus.object.player.rush(player)
    end

    if nexus.input.isKeyDown(NEXUS_KEY.X) then
        nexus.console.showDebugMessage('Player jump')
        nexus.object.player.jump(player)
    end

    if nexus.input.isKeyDown(NEXUS_KEY.C) then
        nexus.console.showDebugMessage('Player attack')
        nexus.object.player.attack(player)
    end

    if nexus.input.isKeyDown(NEXUS_KEY.LEFT) then
        nexus.object.player.left(player)
    end

    if nexus.input.isKeyDown(NEXUS_KEY.RIGHT) then
        nexus.object.player.right(player)
    end

    if nexus.input.isKeyDown(NEXUS_KEY.UP) then
        nexus.object.player.up(player)
    end

    if nexus.input.isKeyDown(NEXUS_KEY.DOWN) then
        nexus.object.player.down(player)
    end

    player.update(player, dt)
    if #instance.objects > 0 then
        for _, v in pairs(instance.objects) do
            v:update(dt)
        end
    end
end

local function draw(instance)
    player.draw(player)
    if #instance.objects > 0 then
        for _, v in pairs(instance.objects) do
            v:draw(v.body:getWorldPoints(v.shape:getPoints()))
        end
    end
end

function nexus.screen.stage.new(stage)
    local instance = {
        enter   = enter,
        leave   = leave,
        update  = update,
        draw    = draw
    }

    instance.stage = nexus.core.load('stage', stage)

    return nexus.screen.loading.new(instance)
end
