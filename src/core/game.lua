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
local Input                 = Core.import 'nexus.core.input'
local Scene                 = Core.import 'nexus.core.scene'
local GameConsole           = Core.import 'nexus.game.console'
local GamePlayer            = Core.import 'nexus.game.player'
local GameMessage           = Core.import 'nexus.game.message'
local GameSystem            = Core.import 'nexus.game.system'
local SceneTitle            = Core.import 'nexus.scene.title'
local SceneExit             = Core.import 'nexus.scene.exit'
local KEYS                  = Constants.KEYS
local VERSION               = Constants.VERSION
local FIRST_RUN             = Constants.FIRST_RUN
local SAVING_FILENAME       = Constants.PATHS.SAVING
local SAVING_SLOT_SIZE      = Constants.SAVING_SLOT_SIZE
local REFERENCE_WIDTH       = Constants.REFERENCE_WIDTH
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Game                  = {
    player                  = nil,
    message                 = nil,
    -- story                   = nil,
    -- stage                   = nil,
    system                  = nil
}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_version             = nil

local MAJOR                 = VERSION.MAJOR
local MINOR                 = VERSION.MINOR
local MICRO                 = VERSION.MICRO
local PATCH                 = VERSION.PATCH

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function on_start_game()
    Graphics.setFramecount(0)
end

local function on_after_load()
    Graphics.setFramecount(Game.system.framecount)
end

local function on_before_save()
    Game.system.framecount = Graphics.getFramecount()
    Game.system.savingcount = Game.system.savingcount + 1
end

local function adjust_screen_mode()
    local best_screen_mode = Graphics.getBestScreenMode()

    local ow = REFERENCE_WIDTH
    local oh = REFERENCE_HEIGHT
    local bw = best_screen_mode.width
    local bh = best_screen_mode.height

    if ow > bw or oh > bh or ow * oh > bw * bh then
        Graphics.changeGraphicsConfigures(true, bw, bh)
    end
end

local function check_game_requirement()
    if not Configures then
        error('You configure file is corrupted or an error occurred while loading!')
    end

    if FIRST_RUN then adjust_screen_mode() end

    return true
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Game.initialize()
end

function Game.finalize()
    Game.system = nil
    -- Game.story = nil
    Game.player = nil

    -- Game.stage = nil
    Game.message = nil
end

function Game.update(dt)
end

function Game.pause()
end

function Game.resume()
end

function Game.start()
    Data.loadTextData(OptionConfigures.language)

    Input.bindKeyEvent('graphics.togglefps', Input.TRIGGER, KEYS.F1, Graphics.toggleFPS)
    Input.bindKeyEvent('gameconsole.toggle', Input.TRIGGER, KEYS.F9, GameConsole.toggle)
    Input.bindKeyEvent('graphics.togglefullscreen', Input.TRIGGER, KEYS.F11, Graphics.toggleFullscreen)
    Input.bindKeyEvent('game.reload', Input.TRIGGER, KEYS.F12, Game.reload)
    Input.bindKeyEvent('game.quit', Input.TRIGGER, KEYS.F4, KEYS.ALTERNATIVE, Game.quit)

    if check_game_requirement() then Scene.goto(SceneTitle.new()) end
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
    Game.player = GamePlayer.new()
    -- Game.story = GameStory.new()
    Game.system = GameSystem.new()

    Game.message = GameMessage.new()
    -- Game.stage = GameStage.new()

    on_start_game()
end

function Game.load(index)
    -- local data = Core.load()

    Game.player = GamePlayer.new(data.player)
    -- Game.story = GameStory.new(data.story)
    Game.system = GameSystem.new(data.system)

    Game.message = GameMessage.new()
    -- Game.stage = GameStage.new()

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

function Game.quit()
    Scene.enter(SceneExit.new())
end

function Game.exit()
    le.push('exit')
end

function Game.reload()
    le.push('reload')
end

function Game.getVersionString()
    if not m_version then
        m_version = MAJOR .. '.' .. MINOR .. '.' .. MICRO
    end
    return m_version
end

return Game
