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
local GameObject            = Core.import 'nexus.game.object'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local GameCharacter         = {
    name                    = nil,
    transparent             = false,
    idle                    = false,
    index                   = 0,
    pattern                 = 0,
    speed                   = 4,
    opacity                 = 1,
    animationcounter        = 0
}

local FRAME_PER_ACTION      = 4

local ANIMATION_WAIT_COUNT  = 60 / FRAME_PER_ACTION

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function GameCharacter.new(derive)
    local instance = setmetatable({}, { __index = setmetatable(derive, { __index = GameObject.new(GameCharacter) }) })
    return instance
end

function GameCharacter.update(instance, dt)
    local animation_wait_count = instance.idle and ANIMATION_WAIT_COUNT or ANIMATION_WAIT_COUNT - instance.speed * 2

    GameObject.update(instance, dt)

    instance.animationcounter = instance.animationcounter + 1
    if instance.animationcounter > animation_wait_count then
        instance.pattern = (instance.pattern + 1) % FRAME_PER_ACTION
        instance.animationcounter = 0
    end
end

return GameCharacter
