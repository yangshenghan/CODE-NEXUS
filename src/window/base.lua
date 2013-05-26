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
local l                     = love
local lg                    = l.graphics
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Data                  = Core.import 'nexus.core.data'
local Graphics              = Core.import 'nexus.core.graphics'
local Font                  = Core.import 'nexus.base.font'
local Tone                  = Core.import 'nexus.base.tone'
local Viewport              = Core.import 'nexus.base.viewport'
local MINIMUM_LINE_HEIGHT   = Constants.MINIMUM_LINE_HEIGHT

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local WindowBase            = {
    font                    = nil,
    tone                    = nil,
    viewport                = nil,
    active                  = false,
    visible                 = false,
    lineheight              = MINIMUM_LINE_HEIGHT,
    openness                = 0,
    opacity                 = 255,
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
function WindowBase.new(derive, x, y, width, height, font)
    local instance = setmetatable({}, { __index = setmetatable(derive, { __index = WindowBase }) })
    instance.x = x or instance.x
    instance.y = y or instance.y
    instance.width = width or instance.width
    instance.height = height or instance.height
    instance.font = font or Data.getFont('window')
    instance.tone = Tone.new()
    Graphics.addDrawable(instance)
    return instance
end

function WindowBase.dispose(instance)
    instance.render = nil
    Graphics.removeDrawable(instance)
end

function WindowBase.isDisposed(instance)
    return instance.render == nil
end

function WindowBase.isVisible(instance)
    return instance.visible
end

function WindowBase.open(instance)
    instance.active = true
    instance.visible = true
end

function WindowBase.close(instance)
    instance.active = false
    instance.visible = false
end

function WindowBase.beforeUpdate(instance, dt)
end

function WindowBase.afterUpdate(instance, dt)
end

function WindowBase.update(instance, dt)
    WindowBase.beforeUpdate(instance, dt)
    WindowBase.afterUpdate(instance, dt)
end

function WindowBase.beforeRender(instance)
    lg.setColor(128, 128, 64, instance.opacity)
    lg.rectangle('line', instance.x - instance.padding, instance.y - instance.padding, instance.width + instance.padding * 2, instance.height + instance.padding * 2)
    lg.push()
    lg.setScissor(instance.x, instance.y, instance.width, instance.height)
end

function WindowBase.afterRender(instance)
    lg.setScissor()
    lg.pop()
end

function WindowBase.render(instance)
    WindowBase.beforeRender(instance)
    WindowBase.afterRender(instance)
end

function WindowBase.calculateLineHeight(instance, texts)
    return math.max(math.max(MINIMUM_LINE_HEIGHT, instance.lineheight), Font.getLineHeight(instance.font))
end

return WindowBase
