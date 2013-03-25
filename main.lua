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

local Audio                 = Core.require 'src.core.audio'
local Data                  = Core.require 'src.core.data'
local Game                  = Core.require 'src.core.game'
local Graphics              = Core.require 'src.core.graphics'
local Input                 = Core.require 'src.core.input'
local Resource              = Core.require 'src.core.resource'
local Scene                 = Core.require 'src.core.scene'

require 'bootstrap'

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_fps                 = 1 / Graphics.getFramerate()

local m_loaded              = false

local m_loading             = true

local m_running             = true

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
    resize                  = function(width, height)
        Graphics.changeGraphicsConfigures(width, height)
    end,
    reload                  = function()
        m_loading = true
        m_running = false
    end,
    framerate               = function(framerate)
        m_fps = 1 / framerate
    end,
    quit                    = function()
        m_running = false
    end
}

-- / ---------------------------------------------------------------------- \ --
-- | Execution section                                                      | --
-- \ ---------------------------------------------------------------------- / --
function love.run()
    local dt = 0

    math.randomseed(os.time())
    math.random()
    math.random()

    while m_loading do
        m_running = true
        m_loading = false

        Audio.initialize()
        Data.initialize()
        Game.initialize()
        Graphics.initialize()
        Input.initialize()
        Resource.initialize()
        Scene.initialize()

        Game.start()
        while m_running do
            le.pump()
            for e, a, b, c, d in le.poll() do
                local handler = HANDLERS[e]
                if handler then handler(a, b, c, d) end
            end

            lt.step()
            dt = lt.getDelta()

            Audio.update(dt)
            Game.update(dt)
            Graphics.update(dt)
            Input.update(dt)
            Scene.update(dt)

            lg.clear()
            Game.render()
            Graphics.render()
            Scene.render()
            lg.present()

            if not GraphicsConfigures.vsync then lt.sleep(m_fps) end
        end
        Game.terminate()

        Scene.finalize()
        Resource.finalize()
        Input.finalize()
        Graphics.finalize()
        Game.finalize()
        Data.finalize()
        Audio.finalize()
    end
end
