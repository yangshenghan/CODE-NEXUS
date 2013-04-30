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
local Game                  = Core.import 'nexus.core.game'
local REFERENCE_WIDTH       = Constants.REFERENCE_WIDTH
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT
local LOGICAL_GRID_SIZE     = Constants.LOGICAL_GRID_SIZE

return {
    events                  = {
        {
            conditions      = {},
            triggers        = {},
            list            = {
                code        = nil,
                indent      = 0,
                parameters  = {}
            }
        }
    },
    width       = 100,
    height      = 50,
    objects     = {
        ground      = {
            x           = 0,
            y           = REFERENCE_HEIGHT - 50,
            width       = REFERENCE_WIDTH,
            height      = 50,
            bodyType    = 'static',
            render      = function(instance)
                love.graphics.setColor(72, 160, 14)
                love.graphics.rectangle('fill', instance.x - Game.map.displayx * LOGICAL_GRID_SIZE, instance.y + Game.map.displayy * LOGICAL_GRID_SIZE, instance.width, instance.height)
            end
        },
        sky         = {
            x           = 0,
            y           = 0,
            width       = REFERENCE_WIDTH,
            height      = 50,
            bodyType    = 'static',
            render      = function(instance)
                love.graphics.setColor(72, 160, 14)
                love.graphics.rectangle('fill', instance.x - Game.map.displayx * LOGICAL_GRID_SIZE, instance.y + Game.map.displayy * LOGICAL_GRID_SIZE, instance.width, instance.height)
            end
        },
        leftwall    = {
            x           = 0,
            y           = 0,
            width       = 50,
            height      = REFERENCE_HEIGHT,
            bodyType    = 'static',
            render      = function(instance)
                love.graphics.setColor(72, 160, 14)
                love.graphics.rectangle('fill', instance.x - Game.map.displayx * LOGICAL_GRID_SIZE, instance.y + Game.map.displayy * LOGICAL_GRID_SIZE, instance.width, instance.height)
            end
        },
        rightwall   = {
            x           = REFERENCE_WIDTH - 50,
            y           = 0,
            width       = 50,
            height      = REFERENCE_HEIGHT,
            bodyType    = 'static',
            render      = function(instance)
                love.graphics.setColor(72, 160, 14)
                love.graphics.rectangle('fill', instance.x - Game.map.displayx * LOGICAL_GRID_SIZE, instance.y + Game.map.displayy * LOGICAL_GRID_SIZE, instance.width, instance.height)
            end
        },
        block1      = {
            x           = 200,
            y           = 550,
            width       = 50,
            height      = 100,
            density     = 5,
            bodyType    = 'dynamic',
            render      = function(instance)
                love.graphics.setColor(50, 50, 50)
                love.graphics.rectangle('fill', instance.x - Game.map.displayx * LOGICAL_GRID_SIZE, instance.y + Game.map.displayy * LOGICAL_GRID_SIZE, instance.width, instance.height)
            end
        },
        block2      = {
            x           = 200,
            y           = 400,
            width       = 100,
            height      = 50,
            density     = 2,
            bodyType    = 'dynamic',
            render      = function(instance)
                love.graphics.setColor(50, 50, 50)
                love.graphics.rectangle('fill', instance.x - Game.map.displayx * LOGICAL_GRID_SIZE, instance.y + Game.map.displayy * LOGICAL_GRID_SIZE, instance.width, instance.height)
            end
        }
    }
}
