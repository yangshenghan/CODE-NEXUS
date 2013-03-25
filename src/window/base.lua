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
local Graphics              = Core.import 'nexus.core.graphics'
local Viewport              = Core.import 'nexus.base.viewport'
local NEXUS_EMPTY_FUNCTION  = Constants.EMPTY_FUNCTION

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local WindowBase            = {
    render                  = NEXUS_EMPTY_FUNCTION,
    update                  = NEXUS_EMPTY_FUNCTION,
    active                  = false,
    visible                 = false,
    openness                = 0,
    padding                 = 12,
    height                  = 0,
    width                   = 0,
    x                       = 0,
    y                       = 0,
    z                       = 0
}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function WindowBase.new(derive)
    local instance = setmetatable({}, { __index = setmetatable(derive, { __index = WindowBase }) })
    Viewport.addDrawable(Graphics.getWindowViewport(), instance)
    return instance
end

function WindowBase.dispose(instance)
    instance.render = nil
    Viewport.removeDrawable(Graphics.getWindowViewport(), instance)
end

function WindowBase.disposed(instance)
    return instance.render == nil
end

-- function WindowBase.update(instance, dt, ...)
    -- if instance.active then
        -- return instance.update(instance, dt, ...)
    -- end
    -- return true
-- end

-- function WindowBase.render(instance, ...)
    -- if instance.visible then
        -- instance.render(instance, ...)
    -- end
-- end

function WindowBase.open(instance)
    instance.active = true
    instance.visible = true
end

function WindowBase.close(instance)
    instance.active = false
    instance.visible = false
end

return WindowBase
