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

nexus.base.scene            = {}

local NEXUS_EMPTY_FUNCTION  = NEXUS_EMPTY_FUNCTION

local t_default             = {
    create                  = NEXUS_EMPTY_FUNCTION,
    delete                  = NEXUS_EMPTY_FUNCTION,
    enter                   = NEXUS_EMPTY_FUNCTION,
    leave                   = NEXUS_EMPTY_FUNCTION,
    idleIn                  = NEXUS_EMPTY_FUNCTION,
    idleOut                 = NEXUS_EMPTY_FUNCTION,
    update                  = NEXUS_EMPTY_FUNCTION,
    -- The render callback may be removed and managed in nexus.game
    render                  = NEXUS_EMPTY_FUNCTION,
    idle                    = false
}

function nexus.base.scene.isIdle(instance)
    return instance.idle
end

function nexus.base.scene.setIdle(instance, idle)
    instance.idle = idle
end

function nexus.base.scene.toggleIdle(instance)
    instance.idle = not instance.idle
end

function nexus.base.scene.new(instance)
    instance = table.merge(t_default, instance)
    instance.create(instance)
    return instance
end
