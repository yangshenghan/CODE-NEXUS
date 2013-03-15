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
nexus.scene.stage = {
    stages  = {}
}

local gravity = 9.81;

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
    instance.objects = {}

    instance.world:setCallbacks(begin_contact, end_contact, pre_solve, post_solve)

    instance.player = nexus.object.player.new(instance.world)

    for _, data in pairs(instance.stage.objects) do
        local object = {}
        object.body = love.physics.newBody(instance.world, data.x, data.y, data.bodyType or 'static')
        object.shape = love.physics.newRectangleShape(data.width, data.height)
        object.fixture = love.physics.newFixture(object.body, object.shape, data.density or 0)
        object.draw = data.draw or function(...) end
        object.update = data.update or function(...) end
        table.insert(instance.objects, object)
    end

    love.graphics.setBackgroundColor(104, 136, 248)
end

local function leave(instance)
    instance.player.delete(instance.player)

    instance.world = nil
    instance.player = nil
end

local function update(instance, dt)
    if instance.idle then return end

    instance.world.update(instance.world, dt)

    if nexus.input.isKeyDown(NEXUS_KEY.Z) then
        nexus.object.player.rush(instance.player)
    end

    if nexus.input.isKeyDown(NEXUS_KEY.X) then
        nexus.object.player.jump(instance.player)
    end

    if nexus.input.isKeyDown(NEXUS_KEY.C) then
        nexus.object.player.attack(instance.player)
    end

    if nexus.input.isKeyDown(NEXUS_KEY.LEFT) then
        nexus.object.player.left(instance.player)
    end

    if nexus.input.isKeyDown(NEXUS_KEY.RIGHT) then
        nexus.object.player.right(instance.player)
    end

    if nexus.input.isKeyDown(NEXUS_KEY.UP) then
        nexus.object.player.up(instance.player)
    end

    if nexus.input.isKeyDown(NEXUS_KEY.DOWN) then
        nexus.object.player.down(instance.player)
    end

    instance.player.update(instance.player, dt)
    if #instance.objects > 0 then
        for _, v in pairs(instance.objects) do
            v:update(dt)
        end
    end
end

local function render(instance)
    instance.player.render(instance.player)

    if #instance.objects > 0 then
        for _, v in pairs(instance.objects) do
            v:draw(v.body:getWorldPoints(v.shape:getPoints()))
        end
    end
end

function nexus.scene.stage.new(stage)
    local instance = {
        enter   = enter,
        leave   = leave,
        update  = update,
        render  = render
    }

    instance.stage = nexus.core.load('stage', stage)

    return nexus.scene.loading.new(instance)
end
