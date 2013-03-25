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
local li                    = l.image
local lg                    = l.graphics
local Nexus                 = nexus
local Core                  = Nexus.core
local Graphics              = Core.import 'nexus.core.graphics'
local Color                 = Core.import 'nexus.base.color'
local WindowBase            = Core.import 'nexus.window.base'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local WindowProgressBar     = {
    x                       = 0,
    y                       = 0,
    width                   = 0,
    height                  = 0,
    progress                = 0,
    image                   = nil
}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function WindowProgressBar.new(x, y, width, height)
    local instance = WindowBase.new(WindowProgressBar)
    instance.x = x or Graphics.getScreenWidth() * 0.15
    instance.y = y or Graphics.getScreenHeight() * 0.8 - 60
    instance.width = width or Graphics.getScreenWidth() * 0.7
    instance.height = height or 60
    instance.visible = true

    do
        local image = li.newImageData(instance.width, instance.height)
        local l = Color.new(128, 255, 128, 255)
        local r = Color.new(255, 128, 128, 255)
        for x = 0, instance.width - 1 do
            local rr = x / instance.width
            local lr = 1 - rr
            for y = 0, instance.height - 1 do
                image.setPixel(image, x, y, l.red * lr + r.red * rr, l.green * lr + r.green * rr, l.blue * lr + r.blue * rr, l.alpha * lr + r.alpha * rr)
            end
        end

        instance.progress = 0
        instance.image = lg.newImage(image)
        instance.image.setFilter(instance.image, 'linear', 'linear')
    end

    return instance
end

function WindowProgressBar.render(instance)
    local rectangle = lg.newQuad(instance.x, instance.y, instance.width * instance.progress, instance.height, instance.width, instance.height)
    lg.setColor(128, 128, 128, 255)
    lg.rectangle('fill', instance.x, instance.y, instance.width, instance.height)
    lg.drawq(instance.image, rectangle, instance.x, instance.y)
end

function WindowProgressBar.getProgressValue(instance)
    return instance.progress
end

function WindowProgressBar.setProgressValue(instance, value)
    if not value then value = 0 end
    if value < 0 then value = 0 end
    if value > 1 then value = 1 end
    instance.progress = value
end

return WindowProgressBar
