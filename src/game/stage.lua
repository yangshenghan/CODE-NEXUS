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
local ipairs                = ipairs
local setmetatable          = setmetatable
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Data                  = Core.import 'nexus.core.data'
local Input                 = Core.import 'nexus.core.input'
local Game                  = Core.import 'nexus.core.game'
local KEYS                  = Constants.KEYS

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local GameStage             = {
    spawns                  = nil
}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local KEY_BINDINGS  = {
    {
        'gamestage.z',
        KEYS.Z,
        function()
            Game.player.rush(Game.player)
        end
    },
    {
        'gamestage.x',
        KEYS.X,
        function()
            Game.player.jump(Game.player)
        end
    },
    {
        'gamestage.c',
        KEYS.C,
        function()
            Game.player.attack(Game.player)
        end
    },
    {
        'gamestage.up',
        KEYS.UP,
        function()
            if Game.player.isPassable(Game.player, Game.player.x, Game.player.y + 1) then
                Game.player.up(Game.player)
            end
        end
    },
    {
        'gamestage.right',
        KEYS.RIGHT,
        function()
            if Game.player.isPassable(Game.player, Game.player.x + 1, Game.player.y) then
                Game.player.right(Game.player)
            end
        end
    },
    {
        'gamestage.down',
        KEYS.DOWN,
        function()
            if Game.player.isPassable(Game.player, Game.player.x, Game.player.y - 1) then
                Game.player.down(Game.player)
            end
        end
    },
    {
        'gamestage.left',
        KEYS.LEFT,
        function()
            if Game.player.isPassable(Game.player, Game.player.x - 1, Game.player.y) then
                Game.player.left(Game.player)
            end
        end
    }
}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function GameStage.new(data)
    local instance = setmetatable({}, { __index = GameStage })
    instance.spawns = {}
    return instance
end

function GameStage.load(stage)
    local data = Data.loadStageData(stage)
    Game.player.move(Game.player, 10, 10)
    return data
end

function GameStage.unload()
    Game.stage.spawns = {}
end

function GameStage.update(dt)
    for _, object in ipairs(Game.stage.spawns) do object.update(object, dt) end
end

function GameStage.spawn(object)
    table.insert(Game.stage.spawns, object)
end

function GameStage.enableKeyBindings()
    for _, binding in ipairs(KEY_BINDINGS) do Input.bindKeyEvent(binding[1], Input.PRESS, binding[2], binding[3]) end
end

function GameStage.disableKeyBindings()
    for _, binding in ipairs(KEY_BINDINGS) do Input.unbindKeyEvent(binding[1]) end
end

return GameStage
