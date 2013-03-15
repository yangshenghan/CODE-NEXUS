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
nexus.object.base = {}

local LOGICAL_GRID_SIZE = nexus.system.parameters.logical_grid_size

local default = {
    create  = function(...) end,
    delete  = function(...) end,
    update  = function(...) end,
    render  = function(...) end,
    object  = {
        x           = 0,        -- logical x position
        y           = 0,        -- logical y position
        rx          = 0,        -- real x position (logical x * LOGICAL_GRID_SIZE)
        ry          = 0         -- real y potition (logical y * LOGICAL_GRID_SIZE)
    }
}

function nexus.object.base.move(instance, x, y)
    if x then
        instance.object.x = x
        instance.object.rx = x * LOGICAL_GRID_SIZE
    end
    if y then
        instance.object.y = y
        instance.object.ry = y * LOGICAL_GRID_SIZE
    end
end

function nexus.object.base.isMoving(instance)
    if instance.object.rx ~= instance.object.x * LOGICAL_GRID_SIZE then return true end
    if instance.object.ry ~= instance.object.y * LOGICAL_GRID_SIZE then return true end
    return false
end

function nexus.object.base.isPassable(instance, x, y)
    local stage = nexus.scene.stage.getCurrentStage()
    if x < 0 or y < 0 then return false end
    if x > stage.width / LOGICAL_GRID_SIZE or y > stage.height / LOGICAL_GRID_SIZE then return false end
    return true
end

function nexus.object.base.new(instance)
    table.recursiveMerge(instance, default)
    instance.create(instance)
    return instance
end