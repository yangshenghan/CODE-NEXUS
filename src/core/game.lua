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
local l             = love
local le            = l.event
local lg            = l.graphics

local Nexus         = nexus
local NexusCore     = Nexus.core

local Data          = require 'src.core.data'
local Scene         = require 'src.core.scene'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
NexusCore.game      = {}

local Game          = NexusCore.game

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local t_saving_data = {}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function on_after_load()
end

local function on_before_save()
    t_saving_data.system.savingcount = t_saving_data.system.savingcount + 1
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
    t_saving_data = Data.loadScriptData('setup')
end

function Game.finalize()
    t_saving_data = {}
end

function Game.update(dt)
end

function Game.render()
end

function Game.start()
    Data.loadTextData(nexus.configures.options.language)
    if nexus.configures and not nexus.system.error and lg.isSupported('canvas') then
        if nexus.system.firstrun then adjust_screen_mode() end
        Scene.goto(nexus.scene.title.new(m_loaded))
        -- Scene.goto(nexus.scene.stage.new('prologue'))
        if nexus.settings.console then
            Scene.enter(nexus.scene.console.new())
        end
        m_loaded = true
    else
        Scene.goto(nexus.scene.error.new(Data.getTranslatedText(nexus.system.error)))
    end
end

function Game.terminate()
end

-- function Game.changeGameplayConfigures()
    -- nexus.game.saveGameConfigure()
-- end

-- function Game.saveGameConfigure()
    -- nexus.core.save(nexus.system.paths.configure, nexus.configures, nexus.system.parameters.configure_identifier)
-- end

function Game.setup()
end

function Game.load(index)
    on_after_load()
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
    for index = 1, nexus.system.parameters.saving_slot_size do
        local filename = string.format(nexus.system.paths.saving, index)
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

return Game
