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
local Configures            = Nexus.configures
local Constants             = Nexus.constants
local OptionConfigures      = Configures.options
local Data                  = Core.import 'nexus.core.data'
local Graphics              = Core.import 'nexus.core.graphics'
local Scene                 = Core.import 'nexus.core.scene'
local GameConsole           = Core.import 'nexus.game.console'
local GamePlayer            = Core.import 'nexus.game.player'
local SceneTitle            = Core.import 'nexus.scene.title'
local SceneExit             = Core.import 'nexus.scene.exit'
local NEXUS_FIRST_RUN       = Constants.FIRST_RUN
local NEXUS_VERSION         = Constants.VERSION

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

local MAJOR                 = NEXUS_VERSION.MAJOR
local MINOR                 = NEXUS_VERSION.MINOR
local MICRO                 = NEXUS_VERSION.MICRO
local PATCH                 = NEXUS_VERSION.PATCH
local SAVING_SLOT_SIZE      = Constants.SAVING_SLOT_SIZE
local SAVING_FILENAME       = Constants.PATHS.SAVING

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

local function check_game_requirement()
    if not Configures then
        error('You configure file is corrupted or an error occurred while loading!')
    end

    if not lg.isSupported('canvas') then
        error('Your graphics card is not supported to use hardware texture render.')
    end

    if NEXUS_FIRST_RUN then adjust_screen_mode() end

    return true
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

function Game.pause()
end

function Game.resume()
end

function Game.start()
    Data.loadTextData(OptionConfigures.language)

    if check_game_requirement() then
        Scene.goto(SceneTitle.new(m_loaded))
    end

    m_loaded = true
end

function Game.terminate()
end

-- function Game.changeGameplayConfigures()
    -- Game.saveGameConfigure()
-- end

-- function Game.saveGameConfigure()
    -- Core.save(Systems.paths.configure, Configures, Constants.CONFIGURE_IDENTIFIER)
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
        local filename = string.format(SAVING_FILENAME, index)
        if Core.exists(filename) then return true end
    end
    return false
end

function Game.reload()
    le.push('reload')
end

function Game.quit()
    Scene.enter(SceneExit.new())
end

function Game.exit()
    le.push('exit')
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
