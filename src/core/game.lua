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

local Nexus                 = nexus
local Core                  = Nexus.core
local Systems               = Nexus.systems
local SystemsVersion        = Systems.version
local Settings              = Nexus.settings
local Configures            = Nexus.configures
local Constants             = Nexus.constants
local OptionConfigures      = Configures.options
local Data                  = Core.import 'nexus.core.data'
local Graphics              = Core.import 'nexus.core.graphics'
local Scene                 = Core.import 'nexus.core.scene'
local GamePlayer            = Core.import 'nexus.game.player'
local SceneTitle            = Core.import 'nexus.scene.title'
local SceneConsole          = Core.import 'nexus.scene.console'
local SceneError            = Core.import 'nexus.scene.error'
local SAVING_SLOT_SIZE      = Constants.SAVING_SLOT_SIZE

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Game                  = {}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_version             = nil

local t_saving_data         = nil

local t_game_objects        = nil

local MAJOR                 = SystemsVersion.major
local MINOR                 = SystemsVersion.minor
local MICRO                 = SystemsVersion.micro
local PATCH                 = SystemsVersion.patch

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function on_start_game()
    Graphics.setFramecount(0)
end

local function on_after_load()
    Graphics.setFramecount(t_saving_data.system.framecount)
end

local function on_before_save()
    t_saving_data.system.framecount = Graphics.getFramecount()
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
end

function Game.finalize()
    t_game_objects = {}
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
        Scene.goto(SceneTitle.new(m_loaded))
        if Systems.debug and Settings.console then Scene.enter(SceneConsole.new()) end
        m_loaded = true
    else
        Scene.goto(SceneError.new(Data.getTranslatedText(Systems.error)))
    end
end

function Game.terminate()
end

-- function Game.changeGameplayConfigures()
    -- nexus.game.saveGameConfigure()
-- end

-- function Game.saveGameConfigure()
    -- nexus.core.save(Systems.paths.configure, nexus.configures, nexus.constants.CONFIGURE_IDENTIFIER)
-- end

function Game.setup()
    t_saving_data = Data.loadScriptData('setup')
    t_game_objects = {
        player              = GamePlayer.new(),
        -- messgae             = GameMessage.new(),
        -- story               = GameStory.new(),
        -- stage               = GameStage.new(),
        -- system              = GameSystem.new()
    }

    on_start_game()
    -- $game_party.setup_starting_members
    -- $game_map.setup($data_system.start_map_id)
    -- $game_player.moveto($data_system.start_x, $data_system.start_y)
    -- $game_player.refresh
end

function Game.load(index)
    -- local data = Core.load()
    t_game_objects = {
        player              = data.player,
        -- messgae             = data.messgae,
        -- story               = data.story,
        -- stage               = data.stage,
        -- system              = data.system
    }

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
    for index = 1, SAVING_SLOT_SIZE do
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

function Game.getGameObjects()
    return t_game_objects
end

return Game
