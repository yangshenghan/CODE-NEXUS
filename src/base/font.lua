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
local Resource              = Core.import 'nexus.core.resource'
local Color                 = Core.import 'nexus.base.color'
local Rectangle             = Core.import 'nexus.base.rectangle'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Font                  = {
    name                    = nil,
    font                    = nil,
    color                   = nil,
    outline                 = nil,
    bold                    = false,
    italic                  = false,
    underline               = false,
    delete                  = false,
    shadow                  = true,
    rotate                  = 0,
    size                    = 24,
    ALIGN_LEFT              = 0,
    ALIGN_JUSTIFY           = 1,
    ALIGN_CENTER            = 2,
    ALIGN_RIGHT             = 3
}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Font.new(name, size)
    local instance = setmetatable({}, { __index = Font })
    instance.color = Color.new(255, 255, 255, 255)
    instance.outline = Color.new(0, 0, 0, 128)
    instance.name = name
    instance.size = size
    instance.font = Resource.loadFontData(name, size)
    Font.setLineHeight(instance, size)
    return instance
end

function Font.getHeight(instance)
    return instance.font.getHeight(instance.font)
end

function Font.getLineHeight(instance)
    return instance.font.getLineHeight(instance.font)
end

function Font.setLineHeight(instance, lineheight)
    return instance.font.setLineHeight(instance.font, lineheight)
end

function Font.getWidth(instance, line)
    return instance.font.getWidth(instance.font, line)
end

function Font.getWrap(instance, text, width)
    return instance.font.getWrap(instance.font, text, width)
end

function Font.getTextRectangle(instance, text)
    local width, lines = Font.getWrap(instance, text, Font.getWidth(instance, text))
    return Rectangle.new(0, 0, width, lines * Font.getHeight(instance))
end

function Font.text(instance, text, ...)
    local x, y, width, height, align = ...
    local scissorx, scissory, scissorw, scissorh = ...

    local sx, sy, zx, zy = 0, 0, 1, 1
    local color = { lg.getColor() }
    local scissor = { lg.getScissor() }

    if not width then
        width = lg.getWidth()
        scissorw = width
    end
    if not height then
        height = lg.getHeight()
        scissorh = height
    end
    if not align then align = Font.ALIGN_LEFT end

    if Font.getHeight(instance) ~= instance.size then
        instance.font = Resource.loadFontData(instance.name, instance.size)
    end

    if instance.shadow then
        scissorw = scissorw + 1
        scissorh = scissorh + 1
    end

    if instance.italic then
        sx = -0.5
        scissorx = scissorx - instance.size * 0.5
        scissorw = scissorw + instance.size * 0.5
    end

    if instance.bold then
        scissorx = scissorx - instance.size * 0.5
        scissorw = scissorw + instance.size * 0.5
    end

    lg.setFont(instance.font)

    lg.setScissor(scissorx, scissory, scissorw, scissorh)

    if align == Font.ALIGN_RIGHT then
        x = math.ceil(x + (width - Font.getWidth(instance, text)))
    elseif align == Font.ALIGN_CENTER then
        x = math.ceil(x + (width - Font.getWidth(instance, text)) * 0.5)
    elseif align == Font.ALIGN_JUSTIFY then
        -- not implement
    else
        x = math.ceil(x)
    end
    y = math.ceil(y)

    if instance.shadow then
        lg.setColor(0, 0, 0, 255)

        lg.print(text, x + 1, y + 1, instance.rotate, zx, zy, 0, 0, sx, sy)

        if instance.delete then
            lg.rectangle('fill', x + 1, y + height / 2 + 4, Font.getWidth(instance, text), 1)
        end

        if instance.underline then
            lg.rectangle('fill', x + 1, y + height, Font.getWidth(instance, text), 1)
        end
    end

    do
        lg.setColor(Color.get(instance.outline))

        if instance.bold then
            lg.print(text, x - 1.5, y - 1, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x - 1.5, y, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x - 1.5, y + 1, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x, y - 1, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x, y + 1, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x + 1.5, y - 1, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x + 1.5, y, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x + 1.5, y + 1, instance.rotate, zx, zy, 0, 0, sx, sy)
        end

        if instance.outline then
            lg.print(text, x - 1, y - 1, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x - 1, y, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x - 1, y + 1, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x, y - 1, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x, y + 1, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x + 1, y - 1, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x + 1, y, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x + 1, y + 1, instance.rotate, zx, zy, 0, 0, sx, sy)
        end
    end

    do
        lg.setColor(Color.get(instance.color))

        if instance.bold then
            lg.print(text, x - 0.5, y, instance.rotate, zx, zy, 0, 0, sx, sy)
            lg.print(text, x + 0.5, y, instance.rotate, zx, zy, 0, 0, sx, sy)
        end

        lg.print(text, x, y, instance.rotate, zx, zy, 0, 0, sx, sy)

        if instance.delete then
            lg.rectangle('fill', x, y + 3 + height / 2, Font.getWidth(instance, text), 1)
        end

        if instance.underline then
            lg.rectangle('fill', x, y + height - 1, Font.getWidth(instance, text), 1)
        end
    end

    lg.setScissor(unpack(scissor))
    lg.setColor(unpack(color))
end

return Font
