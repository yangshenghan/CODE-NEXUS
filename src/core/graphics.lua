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
local Constants             = Nexus.constants
local Configures            = Nexus.configures
local GraphicsConfigures    = Configures.graphics

local Data                  = Core.import 'nexus.core.data'
-- local Resource              = Core.import 'nexus.core.resource'
local Scene                 = Core.import 'nexus.core.scene'

local Rectangle             = require 'src.base.rectangle'
local Viewport              = require 'src.base.viewport'

local REFERENCE_WIDTH       = Constants.REFERENCE_WIDTH
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT

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

local m_fadein_duration     = 0

local m_fadeout_duration    = 0

local m_fullscreen          = GraphicsConfigures.fullscreen

local m_screen_offsetx      = 0

local m_screen_offsety      = 0

local m_caption             = lg.getCaption()

local t_drawables           = {}

local t_torenders           = nil

local t_viewports           = nil

local t_toppest_viewport    = nil

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function zsorter(a, b)
    if not a.viewport then return false end
    if not b.viewport then return true end
    if a.viewport.z == b.viewport.z then
        return a.z < b.z
    else
        return a.viewport.z < b.viewport.z
    end
end

local function fix_aspect_ratio(width, height)
    local best_screen_mode = Graphics.getBestScreenMode()

    if width > height then
        height = width * 9 / 16
    else
        width = height * 16 / 9
    end

    if width > best_screen_mode.width then
        width = best_screen_mode.width
        height = width * 9 / 16
    end

    if height > best_screen_mode.height then
        height = best_screen_mode.height
        width = height * 16 / 9
    end

    return width, height
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Graphics.initialize()
    -- local icon = Resource.loadImage('icon.png')
    local width, height = fix_aspect_ratio(GraphicsConfigures.width, GraphicsConfigures.height)

    Graphics.setFramerate(60)
    Graphics.setFramecount(0)
    Graphics.setBrightness(255)

    -- lg.setIcon(icon)
    lg.reset()
    lg.setDefaultFilter('linear', 'nearest')

    m_screen_offsetx = (lg.getWidth() - width) * 0.5
    m_screen_offsety = (lg.getHeight() - height) * 0.5

    t_toppest_viewport = Viewport.new()
    t_toppest_viewport.visible = true
end

function Graphics.finalize()
    Graphics.reset()
end

function Graphics.reset()
    for _, drawable in pairs(t_drawables) do drawable.dispose(drawable) end

    t_toppest_viewport = nil
    t_viewports = nil
    t_torenders = nil
    t_drawables = {}
end

function Graphics.update(dt)
    t_torenders = {}
    t_viewports = {}

    if m_showfps then
        local fps = lt.getFPS()
        lg.setCaption(string.format('%s - FPS: %d', m_caption, fps))
    end

    if m_fadein_duration > 0 then
        local diff = m_fadein_duration
        m_brightness = (m_brightness * (diff - 1) + 255) / diff
        m_fadein_duration = m_fadein_duration - 1
    end

    if m_fadeout_duration > 0 then
        local diff = m_fadeout_duration
        m_brightness = (m_brightness * (diff - 1)) / diff
        m_fadeout_duration = m_fadeout_duration - 1
    end

    table.sort(t_drawables, zsorter)
    for _, drawable in pairs(t_drawables) do
        local viewport = drawable.viewport
        if not viewport then viewport = t_toppest_viewport end
        if viewport.visible then
            local u, v, w, h = Rectangle.get(viewport.rectangle)

            if not t_torenders[viewport] then
                table.insert(t_viewports, viewport)
                t_torenders[viewport] = {}
            end

            if drawable.visible then
                local dx = drawable.x - u
                local dy = drawable.y - v

                if dx >= 0 and dx <= w and dy >= 0 and dy <= h then
                    table.insert(t_torenders[viewport], drawable)
                end
            end
        end
    end
end

function Graphics.render()
    lg.push()
    lg.translate(m_screen_offsetx, m_screen_offsety)
    lg.scale(math.min(lg.getWidth() / REFERENCE_WIDTH, lg.getHeight() / REFERENCE_HEIGHT))

    lg.setColor(255, 255, 255, 255)

    for _, viewport in pairs(t_viewports) do
        lg.push()
        lg.translate(viewport.ox, viewport.oy)
        for _, drawable in pairs(t_torenders[viewport]) do drawable.render(drawable) end
        lg.pop()
    end

    lg.setColor(0, 0, 0, 255 - m_brightness)
    lg.rectangle('fill', 0, 0, lg.getWidth(), lg.getHeight())

    lg.pop()

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
    m_fadein_duration = duration
    m_fadeout_duration = 0
end

function Graphics.fadeOut(duration)
    m_fadein_duration = 0
    m_fadeout_duration = duration
end

function Graphics.freeze()
    le.push('freeze', true)
end

function Graphics.transition(duration, transition, vague)
    le.push('freeze', false)
end

function Graphics.addDrawable(drawable)
    table.insert(t_drawables, drawable)
end

function Graphics.removeDrawable(drawable)
    table.removeValue(t_drawables, drawable)
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
    local width = GraphicsConfigures.width
    local height = GraphicsConfigures.height
    local fullscreen = not m_fullscreen

    if fullscreen then
        local best_screen_mode = Graphics.getBestScreenMode()
        width = best_screen_mode.width
        height = best_screen_mode.height
    end

    Graphics.changeGraphicsConfigures(false, width, height, fullscreen)
end

function Graphics.toggleFPS()
    m_showfps = not m_showfps
    if not m_showfps then lg.setCaption(m_caption) end
end

function Graphics.changeGraphicsConfigures(save, width, height, fullscreen, vsync, fsaa)
    local width = width or GraphicsConfigures.width
    local height = height or GraphicsConfigures.height
    local fullscreen = fullscreen ~= nil and fullscreen or GraphicsConfigures.fullscreen
    local vsync = vsync ~= nil and vsync or GraphicsConfigures.vsync
    local fsaa = fsaa or GraphicsConfigures.fsaa

    if lg.checkMode(width, height, fullscreen) then
        lg.setMode(width, height, {
            fullscreen          = fullscreen,
            vsync               = vsync,
            fsaa                = fsaa,
            borderless          = GraphicsConfigures.borderless,
            resizable           = GraphicsConfigures.resizable,
            centered            = GraphicsConfigures.centered
        })

        if save then
            GraphicsConfigures.width = width
            GraphicsConfigures.height = height
            GraphicsConfigures.fullscreen = fullscreen
            GraphicsConfigures.vsync = vsync
            GraphicsConfigures.fsaa = fsaa

            Game.saveGameConfigure()
        end

        if fullscreen then
            width, height = fix_aspect_ratio(width, height)
        end

        m_fullscreen = fullscreen
        m_screen_offsetx = (lg.getWidth() - width) * 0.5
        m_screen_offsety = (lg.getHeight() - height) * 0.5
    end
end

return Graphics
