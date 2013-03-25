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
local nexus                 = nexus

nexus.base.object           = {}

local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Systems               = Nexus.systems
local SystemsParameters     = Systems.parameters
local SceneStage            = Core.import 'nexus.scene.stage'
local LOGICAL_GRID_SIZE     = SystemsParameters.logical_grid_size

local NEXUS_EMPTY_FUNCTION  = Constants.EMPTY_FUNCTION

local t_default = {
    create  = NEXUS_EMPTY_FUNCTION,
    delete  = NEXUS_EMPTY_FUNCTION,
    update  = NEXUS_EMPTY_FUNCTION,
    render  = NEXUS_EMPTY_FUNCTION,
    object  = {
        x           = 0,    -- logical x position
        y           = 0,    -- logical y position
        rx          = 0,    -- real x position (logical x * LOGICAL_GRID_SIZE)
        ry          = 0     -- real y potition (logical y * LOGICAL_GRID_SIZE)
    },
    x       = 0,
    y       = 0
}

function nexus.base.object.move(instance, x, y)
    if x then
        instance.object.x = x
        instance.object.rx = x * LOGICAL_GRID_SIZE
    end
    if y then
        instance.object.y = y
        instance.object.ry = y * LOGICAL_GRID_SIZE
    end
end

function nexus.base.object.isMoving(instance)
    if instance.object.rx ~= instance.object.x * LOGICAL_GRID_SIZE then return true end
    if instance.object.ry ~= instance.object.y * LOGICAL_GRID_SIZE then return true end
    return false
end

function nexus.base.object.isPassable(instance, x, y)
    local stage = SceneStage.getCurrentStage()
    if x < 0 or y < 0 then return false end
    if x > stage.width / LOGICAL_GRID_SIZE or y > stage.height / LOGICAL_GRID_SIZE then return false end
    return true
end

function nexus.base.object.new(instance)
    instance = table.merge(t_default, instance)
    instance.create(instance)
    return instance
end
