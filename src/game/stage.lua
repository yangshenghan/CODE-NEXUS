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
local Data                  = Core.import 'nexus.core.data'
local Game                  = Core.import 'nexus.core.game'
local REFERENCE_WIDTH       = Constants.REFERENCE_WIDTH
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT
local LOGICAL_GRID_SIZE     = Constants.LOGICAL_GRID_SIZE

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local GameStage             = {
    displayx                = 0,
    displayy                = 0,
    width                   = 0,
    height                  = 0
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function get_grid_x()
    return REFERENCE_WIDTH / LOGICAL_GRID_SIZE
end

local function get_grid_y()
    return REFERENCE_HEIGHT / LOGICAL_GRID_SIZE
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function GameStage.new(data)
    local instance = setmetatable({}, { __index = GameStage })
    return instance
end

function GameStage.load(stage)
    local data = Data.loadStageData(stage)
    Game.stage.width = data.width
    Game.stage.height = data.height
    return data
end

function GameStage.setDisplayPosition(x, y)
    x = math.max(math.min(x, Game.stage.width - get_grid_x()), 0)
    y = math.max(math.min(y, Game.stage.height - get_grid_y()), 0)
    Game.stage.displayx = (x + Game.stage.width) % Game.stage.width
    Game.stage.displayy = (y + Game.stage.height) % Game.stage.height
end

function GameStage.adjustX(x)
    return x - Game.stage.displayx
end

function GameStage.adjustY(y)
    return y - Game.stage.displayy
end

function GameStage.scrollUp(distance)
    Game.stage.displayy = math.min(Game.stage.displayy + distance, Game.stage.height - get_grid_y())
end

function GameStage.scrollRight(distance)
    Game.stage.displayx = math.min(Game.stage.displayx + distance, Game.stage.width - get_grid_x())
end

function GameStage.scrollDown(distance)
    Game.stage.displayy = math.max(Game.stage.displayy - distance, 0)
end

function GameStage.scrollLeft(distance)
    Game.stage.displayx = math.max(Game.stage.displayx - distance, 0)
end

return GameStage
