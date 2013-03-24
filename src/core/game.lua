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
local lg                    = l.graphics
local require               = require

local Nexus                 = nexus
local Systems               = Nexus.systems
local SystemsVersion        = Systems.version
local Settings              = Nexus.settings
local Configures            = Nexus.configures
local OptionConfigures      = Configures.options

local Data                  = require 'src.core.data'
local Graphics              = require 'src.core.graphics'
local Scene                 = require 'src.core.scene'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Game                  = {}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_version             = nil
local t_saving_data         = {}

local MAJOR                 = SystemsVersion.major
local MINOR                 = SystemsVersion.minor
local MICRO                 = SystemsVersion.micro
local PATCH                 = SystemsVersion.patch

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function on_after_load()
end

local function on_before_save()
    t_saving_data.system.framecount = Graphics.getFramecount()
    t_saving_data.system.savingcount = t_saving_data.system.savingcount + 1
end

local function on_start_game()
    Graphics.setFramecount(t_saving_data.system.framecount)
end

local function adjust_screen_mode()
    local best_screen_mode = Graphics.getBestScreenMode()

    local ow = Graphics.getScreenWidth()
    local oh = Graphics.getScreenHeight()
    local bw = best_screen_mode.width
    local bh = best_screen_mode.height

    if ow > bw or oh > bh or ow * oh > bw * bh then
        if bw > bh then
            Graphics.changeGraphicsConfigures(bw, bw * 9 / 16, fullscreen)
        else
            Graphics.changeGraphicsConfigures(bh * 16 / 9, bh, fullscreen)
        end
    end
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Game.initialize()
end

function Game.finalize()
    t_saving_data = {}
end

function Game.update(dt)
end

function Game.render()
end

function Game.pause()
end

function Game.resume()
end

function Game.start()
    Data.loadTextData(OptionConfigures.language)
    if Configures and not Systems.error and lg.isSupported('canvas') then
        if Systems.firstrun then adjust_screen_mode() end
        Scene.goto(nexus.scene.title.new(m_loaded))
        -- Scene.goto(nexus.scene.stage.new('prologue'))
        if Settings.console then Scene.enter(nexus.scene.console.new()) end
        m_loaded = true
    else
        Scene.goto(nexus.scene.error.new(Data.getTranslatedText(Systems.error)))
    end
end

function Game.terminate()
end

-- function Game.changeGameplayConfigures()
    -- nexus.game.saveGameConfigure()
-- end

-- function Game.saveGameConfigure()
    -- nexus.core.save(Systems.paths.configure, nexus.configures, Systems.parameters.configure_identifier)
-- end

function Game.setup()
    t_saving_data = Data.loadScriptData('setup')
    on_start_game()
end

function Game.load(index)
    on_after_load()
    on_start_game()
    return false
end

function Game.save(index)
    on_before_save()
    return false
end

function Game.delete(index)
    return false
end

function Game.exists()
    for index = 1, Systems.parameters.saving_slot_size do
        local filename = string.format(Systems.paths.saving, index)
        if nexus.core.exists(filename) then return true end
    end
    return false
end

function Game.reload()
    le.push('reload')
end

function Game.quit()
    le.push('quit')
end

function Game.getVersionString()
    if not m_version then
        m_version = MAJOR .. '.' .. MINOR .. '.' .. MICRO
    end
    return m_version
end

return Game
