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

nexus.window.progressbar    = {}

local function render(instance)
    local rectangle = love.graphics.newQuad(instance.x, instance.y, instance.width * instance.progress, instance.height, instance.width, instance.height)
    love.graphics.setColor(128, 128, 128, 255)
    love.graphics.rectangle('fill', instance.x, instance.y, instance.width, instance.height)
    love.graphics.drawq(instance.image, rectangle, instance.x, instance.y)
end

function nexus.window.progressbar.getProgressValue(instance)
    return instance.progress
end

function nexus.window.progressbar.setProgressValue(instance, value)
    if not value then value = 0 end
    if value < 0 then value = 0 end
    if value > 1 then value = 1 end
    instance.progress = value
end

function nexus.window.progressbar.new(x, y, width, height)
    return nexus.base.window.new({
        create      = function(instance)
            local image = love.image.newImageData(instance.width, instance.height)
            local l = nexus.base.color.new(128, 255, 128, 255)
            local r = nexus.base.color.new(255, 128, 128, 255)
            for x = 0, instance.width - 1 do
                local rr = x / instance.width
                local lr = 1 - rr
                for y = 0, instance.height - 1 do
                    image.setPixel(image, x, y, l.red * lr + r.red * rr, l.green * lr + r.green * rr, l.blue * lr + r.blue * rr, l.alpha * lr + r.alpha * rr)
                end
            end

            instance.progress = 0
            instance.image = love.graphics.newImage(image)
            instance.image.setFilter(instance.image, 'linear', 'linear')
        end,
        render      = render,
        x           = x or nexus.core.graphics.getScreenWidth() * 0.15,
        y           = y or nexus.core.graphics.getScreenHeight() * 0.8 - 60,
        width       = width or nexus.core.graphics.getScreenWidth() * 0.7,
        height      = height or 60
    })
end
