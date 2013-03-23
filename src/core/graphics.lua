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
local le                    = l.event
local lt                    = l.timer
local lg                    = l.graphics

local Nexus                 = nexus

local Settings              = Nexus.settings

local Configures            = Nexus.configures
local GraphicsConfigures    = Configures.graphics

local Data                  = require 'src.core.data'
-- local Resource              = require 'src.core.resource'
local Scene                 = require 'src.core.scene'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Graphics              = {}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_framerate           = 60

local m_framecount          = 0

local m_brightness          = 255

local m_caption             = lg.getCaption()

local t_viewports           = {}

local t_background_viewport = nil

local t_window_viewport     = nil

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function viewport_zorder_sorter(a, b)
    return a.z < b.z
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Graphics.initialize()
    -- local icon = Resource.loadImage('icon.png')

    Graphics.setFramerate(60)
    Graphics.setFramecount(0)
    Graphics.setBrightness(255)

    -- lg.setIcon(icon)
    lg.reset()
end

function Graphics.finalize()
    Graphics.reset()
end

function Graphics.reset()
    for _, viewport in pairs(t_viewports) do
        nexus.base.viewport.dispose(viewport)
    end

    t_viewports = {}
    t_window_viewport = nil
    t_background_viewport = nil
end

function Graphics.update(dt)
    if Settings.showfps then
        local fps = lt.getFPS()
        lg.setCaption(m_caption .. ' - FPS: ' .. fps)
    end

    table.sort(t_viewports, viewport_zorder_sorter)

    for _, viewport in pairs(t_viewports) do
        nexus.base.viewport.update(viewport, dt)
    end
end

function Graphics.render()
    for _, viewport in pairs(t_viewports) do
        if not nexus.base.viewport.disposed(viewport) and viewport.visible then
            nexus.base.viewport.render(viewport)
        end
    end

    m_framecount = m_framecount + 1
end

function Graphics.pause()
end

function Graphics.resume()
end

function Graphics.clear()
    lg.setColor(Data.getColor('base'))
end

function Graphics.fadeIn(duration)
end

function Graphics.fadeOut(duration)
end

function Graphics.transition(duration, transition, vague)
end

function Graphics.getScreenWidth()
    return GraphicsConfigures.width
end

function Graphics.getScreenHeight()
    return GraphicsConfigures.height
end

function Graphics.getScreenModes()
    local modes = lg.getModes()
    table.sort(modes, function(a, b) return a.width * a.height < b.width * b.height end)
    return modes
end

function Graphics.getBestScreenMode()
    return table.last(Graphics.getScreenModes())
end

function Graphics.getBackgroundViewport()
    if not t_background_viewport then
        t_background_viewport = nexus.base.viewport.new()
        t_background_viewport.z = 0
    end
    return t_background_viewport
end

function Graphics.getWindowViewport()
    if not t_window_viewport then
        t_window_viewport = nexus.base.viewport.new()
        t_window_viewport.z = 40
    end
    return t_window_viewport
end

function Graphics.getFramerate()
    return m_framerate
end

function Graphics.setFramerate(framerate)
    m_framerate = framerate

    le.push('framerate', framerate)
end

function Graphics.getFramecount()
    return m_framecount
end

function Graphics.setFramecount(framecount)
    m_framecount = framecount
end

function Graphics.getBrightness()
    return m_brightness
end

function Graphics.setBrightness(brightness)
    m_brightness = brightness
end

function Graphics.screenshot()
    return lg.newScreenshot()
end

function Graphics.toggleFullscreen()
    lg.toggleFullscreen()
end

function Graphics.toggleFPS()
    Settings.showfps = not Settings.showfps
    if not Settings.showfps then lg.setCaption(m_caption) end
end

function Graphics.addViewport(viewport)
    table.insert(t_viewports, viewport)
end

function Graphics.removeViewport(viewport)
    table.removeValue(t_viewports, viewport)
end

function Graphics.changeGraphicsConfigures(width, height, fullscreen, vsync, fsaa)
    width = width or nexus.configures.graphics.width
    height = height or nexus.configures.graphics.height
    fullscreen = fullscreen or nexus.configures.graphics.fullscreen
    vsync = vsync or nexus.configures.graphics.vsync
    fsaa = fsaa or nexus.configures.graphics.fsaa

    lg.setMode(width, height, fullscreen, vsync, fsaa)

    nexus.configures.graphics.width = width
    nexus.configures.graphics.height = height
    nexus.configures.graphics.fillscreen = fullscreen
    nexus.configures.graphics.vsync = vsync
    nexus.configures.graphics.fsaa = fsaa

    -- Game.saveGameConfigure()
end

return Graphics
