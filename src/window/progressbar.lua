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
local Constants             = Nexus.constants
local Color                 = Core.import 'nexus.base.color'
local WindowBase            = Core.import 'nexus.window.base'
local REFERENCE_WIDTH       = Constants.REFERENCE_WIDTH
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local WindowProgressBar     = {
    x                       = REFERENCE_WIDTH * 0.15,
    y                       = REFERENCE_HEIGHT * 0.8 - 60,
    width                   = REFERENCE_WIDTH * 0.7,
    height                  = 60,
    progress                = 0,
    image                   = nil
}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function WindowProgressBar.new(x, y, width, height)
    local instance = WindowBase.new(WindowProgressBar, x, y, width, height)

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

    instance.visible = true

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
    instance.progress = math.clamp(0, value, 1)
end

return WindowProgressBar
