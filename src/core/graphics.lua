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
local math                  = math
local pairs                 = pairs
local table                 = table
local string                = string
local collectgarbage        = collectgarbage
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
local Resource              = Core.import 'nexus.core.resource'
local Scene                 = Core.import 'nexus.core.scene'
local Color                 = Core.import 'nexus.base.color'
local Rectangle             = Core.import 'nexus.base.rectangle'
local Viewport              = Core.import 'nexus.base.viewport'
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

local function calaulate_screen_offset(width, height)
    return (lg.getWidth() - width) * 0.5, (lg.getHeight() - height) * 0.5
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Graphics.initialize()
    Graphics.setFramerate(60)
    Graphics.setFramecount(0)
    Graphics.setBrightness(255)

    lg.reset()
    lg.setIcon(Resource.loadSystemImage('icon'))
    lg.setDefaultFilter('linear', 'nearest')

    m_screen_offsetx, m_screen_offsety = calaulate_screen_offset(fix_aspect_ratio(lg.getWidth(), lg.getHeight()))

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
    collectgarbage()
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
        if not viewport.isDisposed(viewport) and viewport.isVisible(viewport) then
            if not t_torenders[viewport] then
                table.insert(t_viewports, viewport)
                t_torenders[viewport] = {}
            end

            if not drawable.isDisposed(drawable) and drawable.isVisible(drawable) then
                table.insert(t_torenders[viewport], drawable)
            end
        end
    end
end

function Graphics.render()
    local scale = math.min(lg.getWidth() / REFERENCE_WIDTH, lg.getHeight() / REFERENCE_HEIGHT)
    lg.push()
    lg.translate(m_screen_offsetx, m_screen_offsety)
    lg.scale(scale)

    for _, viewport in pairs(t_viewports) do
        local x, y, w, h = Rectangle.get(viewport.rectangle)
        lg.push()
        lg.translate(viewport.ox, viewport.oy)
        lg.setScissor(x * scale, y * scale, w * scale, h * scale)
        lg.setColor(Color.get(viewport.color))
        for _, drawable in pairs(t_torenders[viewport]) do drawable.render(drawable) end
        lg.setScissor()
        lg.pop()
    end

    if m_brightness < 255 then
        lg.setColor(0, 0, 0, 255 - m_brightness)
        lg.rectangle('fill', 0, 0, lg.getWidth(), lg.getHeight())
    end

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
    return GraphicsConfigures.framerate
end

function Graphics.setFramerate(framerate)
    GraphicsConfigures.framerate = framerate

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
    m_brightness = math.clamp(0, m_brightness, 255)
end

function Graphics.screenshot()
    return lg.newScreenshot()
end

function Graphics.blur(image, intensity)
    local fx = lg.newShader(Data.getShader('horizontal_blur'))
    local fy = lg.newShader(Data.getShader('vertical_blur'))
    local width = image.getWidth(image)
    local height = image.getHeight(image)
    local canvas = lg.newCanvas(width, height)

    fx.send(fx, 'unit', 1 / width)
    fy.send(fy, 'unit', 1 / height)

    if not intensity or intensity <= 0 then intensity = 1 end

    lg.setCanvas(canvas)
    lg.draw(image)
    while intensity > 0 do
        lg.setShader(fx)
        lg.draw(canvas)
        lg.setShader(fy)
        lg.draw(canvas)
        intensity = intensity - 1
    end
    lg.setShader()
    lg.setCanvas()

    return lg.newImage(canvas.getImageData(canvas))
end

function Graphics.glow(image, intensity)
    local f = lg.newShader(Data.getShader('glow'))
    local width = image.getWidth(image)
    local height = image.getHeight(image)
    local canvas = lg.newCanvas(width, height)

    if intensity then
        f.send(f, 'intensity', intensity)
    end

    lg.setCanvas(canvas)
    lg.setShader(f)
    lg.draw(image)
    lg.setShader()
    lg.setCanvas()

    return lg.newImage(canvas.getImageData(canvas))
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
        m_screen_offsetx, m_screen_offsety = calaulate_screen_offset(width, height)
    end
end

return Graphics
