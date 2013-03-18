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
nexus.object.player = {}

local LOGICAL_GRID_SIZE = nexus.system.parameters.logical_grid_size

local function create(instance)
    nexus.base.object.move(instance, 10, 10)
end

local function delete(instance)
    instance.object.rushing = nil
    instance.object.jumping = nil
    instance.object.attacking = nil
end

local function update(instance, dt)
    if instance.object.rushing then
        coroutine.resume(instance.object.rushing, dt)
    end

    if instance.object.jumping then
        coroutine.resume(instance.object.jumping, dt)
    end

    if instance.object.attacking then
        coroutine.resume(instance.object.attacking, dt)
    end
end

local function render(instance)
    love.graphics.setColor(193, 47, 14)
    love.graphics.circle('fill', instance.object.rx, nexus.configures.graphics.height - instance.object.ry, LOGICAL_GRID_SIZE / 2)
end

function nexus.object.player.rush(instance)
    if not instance.object.rushing then
        instance.object.rushing = coroutine.create(function(dt)
            instance.object.rushing = nil
        end)
    end
end

function nexus.object.player.jump(instance)
    if not instance.object.jumping then
        instance.object.jumping = coroutine.create(function(dt)
            while instance.object.ry < (instance.object.y + 4) * LOGICAL_GRID_SIZE do
                instance.object.ry = instance.object.ry + 4 * LOGICAL_GRID_SIZE * dt * 8
                coroutine.yield()
            end
            while instance.object.ry > instance.object.y * LOGICAL_GRID_SIZE do
                instance.object.ry = instance.object.ry - 4 * LOGICAL_GRID_SIZE * dt * 8
                coroutine.yield()
            end
            instance.object.jumping = nil
        end)
    end
end

function nexus.object.player.attack(instance)
    if not instance.object.attacking then
        instance.object.attacking = coroutine.create(function(dt)
            instance.object.attacking = nil
        end)
    end
end

function nexus.object.player.up(instance)
    nexus.base.object.move(instance, false, instance.object.y + 1)
end

function nexus.object.player.right(instance)
    nexus.base.object.move(instance, instance.object.x + 1, false)
end

function nexus.object.player.down(instance)
    nexus.base.object.move(instance, false, instance.object.y - 1)
end

function nexus.object.player.left(instance)
    nexus.base.object.move(instance, instance.object.x - 1, false)
end

function nexus.object.player.new(world)
    local instance = {
        create  = create,
        delete  = delete,
        update  = update,
        render  = render
    }
    instance.object = nexus.core.database.loadObjectData('player')
    return nexus.base.object.new(instance)
end

