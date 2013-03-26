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

-- / ---------------------------------------------------------------------- \ --
-- | Import modules                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Configures            = Nexus.configures
local GraphicsConfigures    = Configures.graphics
local Data                  = Core.import 'nexus.core.data'
local GameObject            = Core.import 'nexus.game.object'
local LOGICAL_GRID_SIZE     = Constants.LOGICAL_GRID_SIZE

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local GamePlayer            = {}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function GamePlayer.new()
    local instance = GameObject.new(setmetatable(GamePlayer, {}))
    instance.object = Data.loadObjectData('player')
    GameObject.move(instance, 10, 10)
    return instance
end

function GamePlayer.update(instance, dt)
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

function GamePlayer.render(instance)
    love.graphics.setColor(193, 47, 14)
    love.graphics.circle('fill', instance.object.rx, GraphicsConfigures.height - instance.object.ry, LOGICAL_GRID_SIZE / 2)
end

function GamePlayer.rush(instance)
    if not instance.object.rushing then
        instance.object.rushing = coroutine.create(function(dt)
            instance.object.rushing = nil
        end)
    end
end

function GamePlayer.jump(instance)
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

function GamePlayer.attack(instance)
    if not instance.object.attacking then
        instance.object.attacking = coroutine.create(function(dt)
            instance.object.attacking = nil
        end)
    end
end

function GamePlayer.up(instance)
    GameObject.move(instance, false, instance.object.y + 1)
end

function GamePlayer.right(instance)
    GameObject.move(instance, instance.object.x + 1, false)
end

function GamePlayer.down(instance)
    GameObject.move(instance, false, instance.object.y - 1)
end

function GamePlayer.left(instance)
    GameObject.move(instance, instance.object.x - 1, false)
end

return GamePlayer
