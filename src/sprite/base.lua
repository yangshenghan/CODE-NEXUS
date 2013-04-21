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
local setmetatable          = setmetatable
local l                     = love
local lg                    = l.graphics
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Graphics              = Core.import 'nexus.core.graphics'
local Color                 = Core.import 'nexus.base.color'
local Rectangle             = Core.import 'nexus.base.rectangle'
local Tone                  = Core.import 'nexus.base.tone'
local Viewport              = Core.import 'nexus.base.viewport'
local EMPTY_FUNCTION        = Constants.EMPTY_FUNCTION

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SpriteBase            = {
    tone                    = nil,
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

local RADIUS_PER_ROUND      = 2 * math.pi

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SpriteBase.new(derive, viewport)
    local instance = setmetatable({}, { __index = setmetatable(derive, { __index = SpriteBase }) })
    instance.tone = Tone.new()
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

function SpriteBase.getPosition(x, y, rectangle)
    return x - rectangle.width * 0.5, y - rectangle.height * 0.5
end

function SpriteBase.flash(instance, color, duration)
end

function SpriteBase.beforeUpdate(instance, dt)
end

function SpriteBase.afterUpdate(instance, dt)
end

function SpriteBase.update(instance, dt)
    SpriteBase.beforeUpdate(instance, dt)
    SpriteBase.afterUpdate(instance, dt)
end

function SpriteBase.beforeRender(instance)
    local ox = instance.ox
    local oy = instance.oy
    local sx = instance.sx
    local sy = instance.sy
    local zx = math.max(0, instance.zx)
    local zy = math.max(0, instance.zy)
    local angle = instance.angle % RADIUS_PER_ROUND

    if instance.mx then zx = -zx end
    if instance.my then zy = -zy end

    lg.push()
    lg.translate(ox - instance.rectangle.width * 0.5, oy - instance.rectangle.height * 0.5)
    lg.rotate(angle)
    lg.scale(zx, zy)
    lg.shear(sx, sy)
    lg.setColor(SpriteBase.getColor(instance.color, instance.opacity))
end

function SpriteBase.afterRender(instance)
    lg.pop()
end

function SpriteBase.render(instance)
    SpriteBase.beforeRender(instance)
    SpriteBase.afterRender(instance)
end

return SpriteBase
