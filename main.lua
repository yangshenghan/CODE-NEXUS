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
local la                    = l.audio
local le                    = l.event
local lg                    = l.graphics
local lk                    = l.keyboard
local lt                    = l.timer
local os                    = os
local math                  = math
local debug                 = debug
local table                 = table
local pcall                 = pcall
local print                 = print
local string                = string
local tostring              = tostring

local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Configures            = Nexus.configures
local GraphicsConfigures    = Configures.graphics

local Audio                 = Core.import 'nexus.core.audio'
local Data                  = Core.import 'nexus.core.data'
local Game                  = Core.import 'nexus.core.game'
local Graphics              = Core.import 'nexus.core.graphics'
local Input                 = Core.import 'nexus.core.input'
local Resource              = Core.import 'nexus.core.resource'
local Scene                 = Core.import 'nexus.core.scene'
local FALLBACK_WIDTH        = Constants.FALLBACK_WIDTH
local FALLBACK_HEIGHT       = Constants.FALLBACK_HEIGHT

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_fps                 = 0

local m_loading             = true

local m_running             = true

local m_screen_freezed      = false

local HANDLERS              = {
    focus                   = function(focus)
        if focus then
            Scene.resume()
            Input.resume()
            Graphics.resume()
            Game.resume()
            Audio.resume()
        else
            Audio.pause()
            Game.pause()
            Graphics.pause()
            Input.pause()
            Scene.pause()
        end
    end,
    reload                  = function()
        m_loading = true
        m_running = false
    end,
    freeze                  = function(freezed)
        m_screen_freezed = freezed
    end,
    framerate               = function(framerate)
        m_fps = 1 / framerate
    end,
    quit                    = function()
        Game.quit()
    end,
    exit                    = function()
        m_running = false
    end
}

-- / ---------------------------------------------------------------------- \ --
-- | Execution section                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function initialize()
    Nexus(true)

    Audio.initialize()
    Data.initialize()
    Game.initialize()
    Graphics.initialize()
    Input.initialize()
    Resource.initialize()
    Scene.initialize()

    Game.start()
end

local function finalize()
    Game.terminate()

    Scene.finalize()
    Resource.finalize()
    Input.finalize()
    Graphics.finalize()
    Game.finalize()
    Data.finalize()
    Audio.finalize()

    Nexus(false)
end

local function handle()
    le.pump()
    for e, a, b, c, d in le.poll() do
        local handler = HANDLERS[e]
        if handler then handler(a, b, c, d) end
    end
    lt.step()
end

local function update(dt)
    Game.update(dt)
    Input.update(dt)
    Scene.update(dt)
    Audio.update(dt)
    Graphics.update(dt)
end

local function render()
    if not m_screen_freezed then
        lg.clear()
        Graphics.render()
        lg.present()
    end

    if not GraphicsConfigures.vsync then lt.sleep(m_fps) end
end

function l.errhand(message, layer)
    local errors = {}
    local trace = debug.traceback(tostring(message) .. '\n\n', 1 + (layer or 1))

    table.insert(errors, 'Error:\n')

    for line in string.gmatch(trace, '(.-)\n') do
        if not string.match(line, 'boot.lua') then
            line = string.gsub(line, 'stack traceback:', 'Traceback:\n')
            table.insert(errors, line)
        end
    end

    message = table.concat(errors, '\n')
    message = string.gsub(message, '\t', '')
    message = string.gsub(message, '%[string "(.-)"%]', '%1')

    print(message)

    if lg.isCreated() then
        local event

        la.stop()
        le.clear()
        lg.reset()
        lk.setKeyRepeat(0)
        lt.step()

        lg.setFont(lg.newFont(14))
        lg.setBackgroundColor(89, 157, 220)
        lg.setColor(255, 255, 255, 255)

        while true do
            lg.clear()
            lg.printf(message, 70, 70, lg.getWidth() - 140)
            lg.present()

            event, _, _, _ = le.wait()
            if event == 'quit' or event == 'keypressed' then return end
        end
    end
end

function l.releaseerrhand(message, layer)
    local message = string.format(Data.getText('An error has occured that caused %s to stop.\nYou can notify %s about this at %s.'), l._release.title, l._release.author, l._release.url)

    print(message)

    if lg.isCreated() then
        local event
        local version = string.format(Data.getText('LÖVE %s (%s) on %s.'), l._version, l._version_codename, l._os)
        local font = lg.newFont(14)

        lg.setCanvas()
        lg.setShader()
        lg.setMode(FALLBACK_WIDTH, FALLBACK_HEIGHT, {
            fullscreen      = false,
            vsync           = false,
            fsaa            = 0,
            borderless      = true,
            resizable       = false,
            centered        = true
        })

        la.stop()
        le.clear()
        lg.reset()
        lk.setKeyRepeat(0)
        lt.step()

        lg.setFont(font)
        lg.setBackgroundColor(89, 157, 220)
        lg.setColor(255, 255, 255, 255)

        while true do
            lg.clear()
            lg.printf(message, 30, 30, lg.getWidth() - 60)
            lg.printf(version, 30, lg.getHeight() - 30, lg.getWidth() - 60, 'right')
            lg.present()

            event, _, _, _ = le.wait()
            if event == 'quit' or event == 'keypressed' then return end
        end
    end
end

function l.run()
    math.randomseed(os.time())
    math.random()
    math.random()

    while m_loading do
        m_running = true
        m_loading = false

        initialize()
        while m_running do
            handle()
            update(lt.getDelta())
            render()
        end
        finalize()
    end
end
