--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-15                                                    ]]--
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
nexus.graphics = {}

local m_caption = love.graphics.getCaption()

function nexus.graphics.initialize()
    -- local icon = nexus.resource.loadImage('icon.png')

    -- love.graphics.setIcon(icon)
    love.graphics.setBackgroundColor(0, 0, 0)
end

function nexus.graphics.finalize()
end

function nexus.graphics.update()
    if nexus.settings.showfps then
        local fps = love.timer.getFPS()
        love.graphics.setCaption(m_caption .. ' - FPS: ' .. fps)
    end
end

function nexus.graphics.render()
end

function nexus.graphics.toggleFullscreen()
    love.graphics.toggleFullscreen()
end

function nexus.graphics.toggleFPS()
    nexus.settings.showfps = not nexus.settings.showfps
    if not nexus.settings.showfps then
        love.graphics.setCaption(m_caption)
    end
end

function nexus.graphics.getScreenModes()
    local modes = love.graphics.getModes()
    table.sort(modes, function(a, b) return a.width * a.height < b.width * b.height end)
    return modes
end

function nexus.graphics.getBestScreenMode()
    return table.last(nexus.utility.getScreenModes())
end

function nexus.graphics.screenshot()
    return love.graphics.newScreenshot()
end

function nexus.graphics.changeGraphicsConfigures(width, height, fullscreen, vsync, fsaa)
    width = width or nexus.configures.graphics.width
    height = height or nexus.configures.graphics.height
    fullscreen = fullscreen or nexus.configures.graphics.fullscreen
    vsync = vsync or nexus.configures.graphics.vsync
    fsaa = fsaa or nexus.configures.graphics.fsaa

    love.graphics.setMode(width, height, fullscreen, vsync, fsaa)

    nexus.configures.graphics.width = width
    nexus.configures.graphics.height = height
    nexus.configures.graphics.fillscreen = fullscreen
    nexus.configures.graphics.vsync = vsync
    nexus.configures.graphics.fsaa = fsaa

    nexus.game.saveGameConfigure()
end
