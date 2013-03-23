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
require 'bootstrap'

local l = love
local le = l.event
local lt = l.timer
local lg = l.graphics

local Game                  = {}

local Audio                 = require 'src/core/audio'
local Nexus                 = nexus
local NexusCore             = Nexus.core
local AudioManager          = NexusCore.audio
local DatabaseManager       = NexusCore.database
local GraphicsManager       = NexusCore.graphics
local InputManager          = NexusCore.input
local MessageManager        = NexusCore.message
local ResourceManager       = NexusCore.resource
local SceneManager          = NexusCore.scene

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_loaded = false

local m_loading = true

local m_running = true

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function adjust_screen_mode()
    local best_screen_mode = GraphicsManager.getBestScreenMode()

    local ow = GraphicsManager.getScreenWidth()
    local oh = GraphicsManager.getScreenHeight()
    local bw = best_screen_mode.width
    local bh = best_screen_mode.height

    if ow > bw or oh > bh or ow * oh > bw * bh then
        if bw > bh then
            GraphicsManager.changeGraphicsConfigures(bw, bw * 9 / 16, fullscreen)
        else
            GraphicsManager.changeGraphicsConfigures(bh * 16 / 9, bh, fullscreen)
        end
    end
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Game.initialize()
    local databases = {
        colors  = 'color'
    }

    AudioManager.initialize()
    DatabaseManager.initialize(databases)
    GraphicsManager.initialize()
    InputManager.initialize()
    MessageManager.initialize()
    ResourceManager.initialize()
    SceneManager.initialize()

    -- nexus.game.data = nil
    DatabaseManager.loadTextData(nexus.configures.options.language)

    if nexus.configures and not nexus.system.error and love.graphics.isSupported('canvas') then
        if nexus.system.firstrun then adjust_screen_mode() end
        SceneManager.goto(nexus.scene.title.new(m_loaded))
        -- SceneManager.goto(nexus.scene.stage.new('prologue'))
        if nexus.settings.console then
            SceneManager.enter(nexus.scene.console.new())
        end
        m_loaded = true
    else
        SceneManager.goto(nexus.scene.error.new(DatabaseManager.getTranslatedText(nexus.system.error)))
    end
end

function Game.finalize()
    SceneManager.finalize()
    ResourceManager.finalize()
    nexus.core.message.finalize()
    InputManager.finalize()
    GraphicsManager.finalize()
    DatabaseManager.finalize()
    AudioManager.finalize()
end

function Game.update(dt)
    AudioManager.update(dt)
    GraphicsManager.update(dt)
    InputManager.update(dt)
    nexus.core.message.update(dt)
    SceneManager.update(dt)
end

function Game.render()
    GraphicsManager.render()
    nexus.core.message.render()
    SceneManager.render()
end

function Game.pause()
    AudioManager.pause()
    GraphicsManager.pause()
    InputManager.pause()
    nexus.core.message.pause()
    SceneManager.pause()
end

function Game.resume()
    SceneManager.resume()
    nexus.core.message.resume()
    InputManager.resume()
    GraphicsManager.resume()
    AudioManager.resume()
end

function Game.focus(focus)
    if focus then Game.resume() else Game.pause() end
end

function Game.resize(width, height)
    local ow, oh, flags = lg.getMode()
    lg.setMode(width, height, flags)
end

function Game.reload()
    m_loading = true
end

function Game.quit()
    m_running = false
end

-- / ---------------------------------------------------------------------- \ --
-- | Public functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function reload()
    le.push('reload')
end

function quit()
    le.push('quit')
end

-- function nexus.game.changeGameplayConfigures()
    -- nexus.game.saveGameConfigure()
-- end

-- function nexus.game.saveGameConfigure()
    -- nexus.core.save(nexus.system.paths.configure, nexus.configures, nexus.system.parameters.configure_identifier)
-- end

function love.run()
    math.randomseed(os.time())
    math.random()
    math.random()

    while m_loading do
        Game.initialize()

        m_loading = false
        while m_running do
            le.pump()
            for e, a, b, c, d in le.poll() do
                local handler = Game[e]
                if handler then handler(a, b, c, d) end
            end

            lt.step()
            Game.update(lt.getDelta())

            lg.clear()
            Game.render()
            lg.present()

            lt.sleep(0.001)
        end
        Game.finalize()
    end
end
