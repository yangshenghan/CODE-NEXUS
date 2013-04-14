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
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Graphics              = Core.import 'nexus.core.graphics'
local Color                 = Core.import 'nexus.base.color'
local Rectangle             = Core.import 'nexus.base.rectangle'
local Viewport              = Core.import 'nexus.base.viewport'
local EMPTY_FUNCTION        = Constants.EMPTY_FUNCTION

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SpriteBase            = {
    color                   = nil,
    rectangle               = nil,
    viewport                = nil,
    image                   = nil,
    visible                 = false,
    mx                      = false,
    my                      = false,
    angle                   = 0,
    opacity                 = 1,
    ox                      = 0,
    oy                      = 0,
    sx                      = 0,
    sy                      = 0,
    x                       = 0,
    y                       = 0,
    z                       = 0,
    zx                      = 1,
    zy                      = 1
}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SpriteBase.new(derive, viewport)
    local instance = setmetatable({}, { __index = setmetatable(derive, { __index = SpriteBase }) })
    instance.color = Color.new(255, 255, 255, 255)
    instance.viewport = viewport
    instance.rectangle = Rectangle.new()
    Graphics.addDrawable(instance)
    return instance
end

function SpriteBase.dispose(instance)
    instance.render = nil
    Graphics.removeDrawable(instance)
end

function SpriteBase.isDisposed(instance)
    return instance.render == nil
end

function SpriteBase.isVisible(instance)
    return instance.visible
end

function SpriteBase.getWidth(instance)
    return instacne.rectangle.width
end

function SpriteBase.getHeight(instance)
    return instance.rectangle.height
end

function SpriteBase.getColor(color, opacity)
    local red, green, blue, alpha = Color.get(color)
    if opacity then alpha = alpha * math.clamp(0, opacity, 1) end
    return red, green, blue, alpha
end

function SpriteBase.flash(instance, color, duration)
end

function SpriteBase.update(instance)
end

return SpriteBase
