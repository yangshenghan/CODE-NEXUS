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
local WindowBase            = Core.import 'nexus.window.base'
local REFERENCE_WIDTH       = Constants.REFERENCE_WIDTH

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local WindowMessage         = {
    coroutine               = nil
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function f_message_coroutine(instance)
    instance.coroutine = nil
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function WindowMessage.new()
    local padding = 12
    local lineheight = 24
    local instance = WindowBase.new(WindowMessage)
    instance.x = 0
    instance.y = 0
    instance.width = REFERENCE_WIDTH
    instance.height = 4 * lineheight + 2 * padding
    return instance
end

function WindowMessage.update(instance, dt)
    if instance.coroutine then
        coroutine.resume(instance.coroutine, instance)
    elseif Game.message.isBusy() then
        instance.coroutine = coroutine.create(f_message_coroutine)
        coroutine.resume(instance.coroutine, instance)
    else
        message.visible = false
    end
end

return WindowMessage
