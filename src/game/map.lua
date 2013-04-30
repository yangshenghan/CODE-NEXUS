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
local math                  = math
local setmetatable          = setmetatable
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
local GameMap               = {
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
function GameMap.new(data)
    local instance = setmetatable({}, { __index = GameMap })
    return instance
end

function GameMap.load(map)
    local data = Data.loadMapData(map)
    Game.map.width = data.width
    Game.map.height = data.height
    return data
end

function GameMap.setDisplayPosition(x, y)
    x = math.max(math.min(x, Game.map.width - get_grid_x()), 0)
    y = math.max(math.min(y, Game.map.height - get_grid_y()), 0)
    Game.map.displayx = (x + Game.map.width) % Game.map.width
    Game.map.displayy = (y + Game.map.height) % Game.map.height
end

function GameMap.adjustX(x)
    return x - Game.map.displayx
end

function GameMap.adjustY(y)
    return y - Game.map.displayy
end

function GameMap.scrollUp(distance)
    Game.map.displayy = math.min(Game.map.displayy + distance, Game.map.height - get_grid_y())
end

function GameMap.scrollRight(distance)
    Game.map.displayx = math.min(Game.map.displayx + distance, Game.map.width - get_grid_x())
end

function GameMap.scrollDown(distance)
    Game.map.displayy = math.max(Game.map.displayy - distance, 0)
end

function GameMap.scrollLeft(distance)
    Game.map.displayx = math.max(Game.map.displayx - distance, 0)
end

return GameMap
