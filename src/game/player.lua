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
local Data                  = Core.import 'nexus.core.data'
local Game                  = Core.import 'nexus.core.game'
local Input                 = Core.import 'nexus.core.input'
local GameObject            = Core.import 'nexus.game.object'
local GameCharacter         = Core.import 'nexus.game.character'
local REFERENCE_WIDTH       = Constants.REFERENCE_WIDTH
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT
local LOGICAL_GRID_SIZE     = Constants.LOGICAL_GRID_SIZE

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local GamePlayer            = {
    last_logical_x          = 0,
    last_logical_y          = 0
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function get_center_x()
    return (REFERENCE_WIDTH / LOGICAL_GRID_SIZE - 1) * 0.5
end

local function get_center_y()
    return (REFERENCE_HEIGHT / LOGICAL_GRID_SIZE - 1) * 0.5
end

-- local function center(x, y)
    -- Game.stage.setDisplayPosition(x - get_center_x(), y - get_center_y())
-- end

local function update_screen_scroll(instance)
    local cx = get_center_x()
    local cy = get_center_y()
    local x1 = Game.stage.adjustX(instance.last_logical_x)
    local y1 = Game.stage.adjustY(instance.last_logical_y)
    local x2 = Game.stage.adjustX(instance.x)
    local y2 = Game.stage.adjustY(instance.y)

    if y2 > y1 and y2 > cy then Game.stage.scrollUp(y2 - y1) end
    if x2 > x1 and x2 > cx then Game.stage.scrollRight(x2 - x1) end
    if y2 < y1 and y2 < cy then Game.stage.scrollDown(y1 - y2) end
    if x2 < x1 and x2 < cx then Game.stage.scrollLeft(x1 - x2) end

    instance.last_logical_x = instance.x
    instance.last_logical_y = instance.y
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function GamePlayer.new()
    local instance = GameCharacter.new(GamePlayer)
    instance.object = Data.loadObjectData('player')
    return instance
end

function GamePlayer.update(instance, dt)
    GameCharacter.update(instance, dt)

    if instance.rushing then
        coroutine.resume(instance.rushing, dt)
    end

    if instance.jumping then
        coroutine.resume(instance.jumping, dt)
    end

    if instance.attacking then
        coroutine.resume(instance.attacking, dt)
    end

    update_screen_scroll(instance)
end

function GamePlayer.rush(instance)
    if not instance.rushing then
        instance.rushing = coroutine.create(function(dt)
            instance.rushing = nil
        end)
    end
end

function GamePlayer.jump(instance)
    if not instance.jumping then
        instance.jumping = coroutine.create(function(dt)
            while instance.ry < (instance.y + 4) * LOGICAL_GRID_SIZE do
                instance.ry = instance.ry + 4 * LOGICAL_GRID_SIZE * dt * 8
                coroutine.yield()
            end
            while instance.ry > instance.y * LOGICAL_GRID_SIZE do
                instance.ry = instance.ry - 4 * LOGICAL_GRID_SIZE * dt * 8
                coroutine.yield()
            end
            instance.jumping = nil
        end)
    end
end

function GamePlayer.attack(instance)
    if not instance.attacking then
        instance.attacking = coroutine.create(function(dt)
            instance.attacking = nil
        end)
    end
end

function GamePlayer.up(instance)
    GameObject.move(instance, false, instance.y + 1)
end

function GamePlayer.right(instance)
    GameObject.move(instance, instance.x + 1, false)
end

function GamePlayer.down(instance)
    GameObject.move(instance, false, instance.y - 1)
end

function GamePlayer.left(instance)
    GameObject.move(instance, instance.x - 1, false)
end

return GamePlayer
