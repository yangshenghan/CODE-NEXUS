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
local Core                  = Nexus.core
local Configures            = Nexus.configures
local GraphicsConfigures    = Configures.graphics

local Data                  = Core.import 'nexus.core.data'
-- local Resource              = Core.import 'nexus.core.resource'
local Scene                 = Core.import 'nexus.core.scene'

local Rectangle             = require 'src.base.rectangle'
local Viewport              = require 'src.base.viewport'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Graphics              = {}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_showfps             = true

local m_framerate           = 60

local m_framecount          = 0

local m_brightness          = 255

local m_caption             = lg.getCaption()

local t_drawables           = {}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --

local function drawable_zorder_sorter(a, b)
    if not a.viewport then return false end
    if not b.viewport then return true end
    if a.viewport.z == b.viewport.z then
        return a.z < b.z
    else
        return a.viewport.z < b.viewport.z
    end
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
    for _, drawable in pairs(t_drawables) do drawable.dispose(drawable) end

    t_drawables = {}
end

function Graphics.update(dt)
    if m_showfps then
        local fps = lt.getFPS()
        lg.setCaption(string.format('%s - FPS: %d', m_caption, fps))
    end

    table.sort(t_drawables, drawable_zorder_sorter)
end

function Graphics.render()
    for _, drawable in pairs(t_drawables) do
        if not drawable.disposed(drawable) and drawable.visible then
            if drawable.viewport then
                local viewport = drawable.viewport
                if viewport.visible then
                    local u, v, w, h = Rectangle.get(viewport.rectangle)
                    local dx = drawable.x - u
                    local dy = drawable.y - v
                    lg.push()
                    lg.translate(viewport.ox, viewport.oy)
                    if dx >= 0 and dx <= w and dy >= 0 and dy <= h then
                        drawable.render(drawable)
                    end
                    lg.pop()
                end
            else
                drawable.render(drawable)
            end
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

function Graphics.addDrawable(drawable)
    table.insert(t_drawables, drawable)
end

function Graphics.removeDrawable(drawable)
    table.removeValue(t_drawables, drawable)
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
    if lg.toggleFullscreen() then
        GraphicsConfigures.fullscreen = not GraphicsConfigures.fullscreen
    end
end

function Graphics.toggleFPS()
    m_showfps = not m_showfps
    if not m_showfps then lg.setCaption(m_caption) end
end

function Graphics.changeGraphicsConfigures(width, height, fullscreen, vsync, fsaa)
    GraphicsConfigures.width = width or GraphicsConfigures.width
    GraphicsConfigures.height = height or GraphicsConfigures.height
    GraphicsConfigures.fullscreen = fullscreen ~= nil and fullscreen or GraphicsConfigures.fullscreen 
    GraphicsConfigures.vsync = vsync ~= nil and vsync or GraphicsConfigures.vsync 
    GraphicsConfigures.fsaa = fsaa or GraphicsConfigures.fsaa

    lg.setMode(GraphicsConfigures.width, GraphicsConfigures.height, {
        fullscreen          = GraphicsConfigures.fullscreen,
        vsync               = GraphicsConfigures.vsync,
        fsaa                = GraphicsConfigures.fsaa,
        borderless          = GraphicsConfigures.borderless,
        resizable           = GraphicsConfigures.resizable,
        centered            = GraphicsConfigures.centered
    })

    -- Game.saveGameConfigure()
end

return Graphics
