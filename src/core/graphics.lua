--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-19                                                    ]]--
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

nexus.core.graphics = {}

local m_caption = love.graphics.getCaption()

local t_viewports = {}

local t_background_viewport = nil

local t_window_viewport = nil

local function viewport_zorder_sorter(a, b)
    return a.z < b.z
end

function nexus.core.graphics.initialize()
    -- local icon = nexus.core.resource.loadImage('icon.png')

    -- love.graphics.setIcon(icon)
    love.graphics.reset()
end

function nexus.core.graphics.finalize()
    nexus.core.graphics.reset()
end

function nexus.core.graphics.update(dt)
    if nexus.settings.showfps then
        local fps = love.timer.getFPS()
        love.graphics.setCaption(m_caption .. ' - FPS: ' .. fps)
    end

    table.sort(t_viewports, viewport_zorder_sorter)

    for _, viewport in pairs(t_viewports) do
        nexus.base.viewport.update(viewport, dt)
    end
end

function nexus.core.graphics.render()
    for _, viewport in pairs(t_viewports) do
        if viewport.visible then nexus.base.viewport.render(viewport) end
    end
end

function nexus.core.graphics.pause()
end

function nexus.core.graphics.resume()
end

function nexus.core.graphics.reset()
    for _, viewport in pairs(t_viewports) do
        nexus.base.viewport.dispose(viewport)
    end

    t_viewports = {}
    t_window_viewport = nil
    t_background_viewport = nil
end

function nexus.core.graphics.clear()
    love.graphics.setColor(nexus.core.database.getColor('base'))
end

function nexus.core.graphics.getScreenWidth()
    return nexus.configures.graphics.width
end

function nexus.core.graphics.getScreenHeight()
    return nexus.configures.graphics.height
end

function nexus.core.graphics.getScreenModes()
    local modes = love.graphics.getModes()
    table.sort(modes, function(a, b) return a.width * a.height < b.width * b.height end)
    return modes
end

function nexus.core.graphics.getBestScreenMode()
    return table.last(nexus.core.graphics.getScreenModes())
end

function nexus.core.graphics.getBackgroundViewport()
    if not t_background_viewport then
        t_background_viewport = nexus.base.viewport.new()
        t_background_viewport.z = 0
    end
    return t_background_viewport
end

function nexus.core.graphics.getWindowViewport()
    if not t_window_viewport then
        t_window_viewport = nexus.base.viewport.new()
        t_window_viewport.z = 40
    end
    return t_window_viewport
end

function nexus.core.graphics.screenshot()
    return love.graphics.newScreenshot()
end

function nexus.core.graphics.toggleFullscreen()
    love.graphics.toggleFullscreen()
end

function nexus.core.graphics.toggleFPS()
    nexus.settings.showfps = not nexus.settings.showfps
    if not nexus.settings.showfps then
        love.graphics.setCaption(m_caption)
    end
end

function nexus.core.graphics.addViewport(viewport)
    table.insert(t_viewports, viewport)
end

function nexus.core.graphics.removeViewport(viewport)
    table.removeValue(t_viewports, viewport)
end

function nexus.core.graphics.changeGraphicsConfigures(width, height, fullscreen, vsync, fsaa)
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
