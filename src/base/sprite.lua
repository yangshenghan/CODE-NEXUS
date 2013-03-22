--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-22                                                    ]]--
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
local nexus = nexus

nexus.base.sprite = {}

local t_default = {
    color       = nil,
    render      = nil,
    angle       = 0,
    mx          = false,
    my          = false,
    image       = nil,
    opacity     = 1,
    ox          = 0,
    oy          = 0,
    rectangle   = nil,
    sx          = 0,
    sy          = 0,
    visible     = true,
    viewport    = nil,
    x           = 0,
    y           = 0,
    z           = 0,
    zx          = 1,
    zy          = 1
}

local function transform_opacity_color(color, opacity)
    if opacity < 0 then opacity = 0 end
    if opacity > 1 then opacity = 1 end
    return color.red, color.green, color.blue, color.alpha * opacity
end

function nexus.base.sprite.dispose(instance)
    instance.render = nil
    nexus.base.viewport.removeDrawable(instance.viewport, instance)
end

function nexus.base.sprite.isDisposed(instance)
    return instance.render == nil
end

function nexus.base.sprite.setImage(instance, image)
    instance.image = image
    instance.rectangle.width = image.getWidth(image)
    instance.rectangle.height = image.getHeight(image)
end

function nexus.base.sprite.getWidth(instance)
    return instacne.rectangle.width
end

function nexus.base.sprite.getHeight(instance)
    return instance.rectangle.height
end

function nexus.base.sprite.render(instance)
    if not nexus.base.sprite.isDisposed(instance) and instance.image then
        local src = instance.image
        local rect = instance.rectangle
        local quad = love.graphics.newQuad(rect.x, rect.y, rect.width, rect.height, src.getWidth(src), src.getHeight(src))
        love.graphics.setColor(transform_opacity_color(instance.color, instance.opacity))
        love.graphics.drawq(instance.image, quad, instance.x - rect.width / 2, instance.y - rect.height / 2, instance.angle, instance.zx, instance.zy, instance.ox, instance.oy, instance.sx, instance.sy)
    end
end

function nexus.base.sprite.new(instance, viewport)
    instance = table.merge(t_default, instance)
    instance.render = nexus.base.sprite.render
    if viewport then
        instance.viewport = viewport
        nexus.base.viewport.addDrawable(instance.viewport, instance)
    end
    instance.color = instance.color or nexus.base.color.new(255, 255, 255, 255)
    instance.rectangle = instance.rectangle or nexus.base.rectangle.new()
    return instance 
end
