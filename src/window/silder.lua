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
local l                     = love
local li                    = l.image
local lg                    = l.graphics
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Graphics              = Core.import 'nexus.core.graphics'
local Input                 = Core.import 'nexus.core.input'
local Color                 = Core.import 'nexus.base.color'
local WindowBase            = Core.import 'nexus.window.base'
local KEYS                  = Constants.KEYS
local EMPTY_FUNCTION        = Constants.EMPTY_FUNCTION

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local WindowSilder          = {
    x                       = 0,
    y                       = 0,
    width                   = 0,
    height                  = 0,
    step                    = 10,
    value                   = 0,
    minimun                 = 0,
    maximun                 = 100,
    callback                = EMPTY_FUNCTION
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function increase_silder_value(instance)
    instance.value = math.min(instance.value + instance.step, instance.maximun)
    instance.callback(instance.value)
end

local function decrease_silder_value(instance)
    instance.value = math.max(instance.value - instance.step, instance.minimun)
    instance.callback(instance.value)
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function WindowSilder.new(x, y, width, height)
    local instance = WindowBase.new(WindowSilder, x, y, width, height)

    return instance
end

function WindowSilder.update(instance, dt)
    WindowBase.beforeUpdate(instance, dt)
    if Input.isKeyRepeat(KEYS.RIGHT) then increase_silder_value(instance) end
    if Input.isKeyRepeat(KEYS.LEFT) then decrease_silder_value(instance) end
    WindowBase.afterUpdate(instance, dt)
end

function WindowSilder.render(instance)
    WindowBase.beforeRender(instance)
    lg.setColor(64, 64, 64, 255)
    lg.rectangle('fill', instance.x, instance.y + 2, instance.width, instance.height - 4)
    lg.setColor(128, 128, 128, 255)
    lg.rectangle('fill', instance.x + instance.width * instance.value / (instance.maximun - instance.minimun) - 2, instance.y, 4, instance.height)
    WindowBase.afterRender(instance)
end

function WindowSilder.setStepValue(instance, step)
    instance.step = step
end

function WindowSilder.setMinimunValue(instance, minimun)
    instance.minimun = minimun
end

function WindowSilder.setMaximunValue(instance, maximun)
    instance.maximun = maximun
end

function WindowSilder.setValue(instance, value)
    instance.value = math.clamp(instance.minimun, value, instance.maximun)
end

function WindowSilder.getValue(instance)
    return instance.value
end

function WindowSilder.bindCallback(instance, callback)
    instance.callback = callback
end

return WindowSilder
