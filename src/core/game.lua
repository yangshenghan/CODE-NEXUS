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
local error                 = error
local string                = string
local l                     = love
local le                    = l.event
local lg                    = l.graphics
local lf                    = l.filesystem
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
local GameMap               = Core.import 'nexus.game.map'
local GameStage             = Core.import 'nexus.game.stage'
local GameScript            = Core.import 'nexus.game.script'
local GameSystem            = Core.import 'nexus.game.system'
local SceneTitle            = Core.import 'nexus.scene.title'
local SceneExit             = Core.import 'nexus.scene.exit'
local KEYS                  = Constants.KEYS
local VERSION               = Constants.VERSION
local FIRST_RUN             = Constants.FIRST_RUN
local DEBUG_MODE            = Constants.DEBUG_MODE
local SAVING_FILENAME       = Constants.PATHS.SAVING
local SAVING_SLOT_SIZE      = Constants.SAVING_SLOT_SIZE
local SAVEINFO_FILENAME     = Constants.PATHS.SAVEINFO
local REFERENCE_WIDTH       = Constants.REFERENCE_WIDTH
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Game                  = {
    player                  = nil,
    message                 = nil,
    -- story                   = nil,
    map                     = nil,
    stage                   = nil,
    script                  = nil,
    system                  = nil
}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_version             = nil

local m_saveinfo            = nil

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

local function get_updated_saveinfo()
    return m_saveinfo
end

local function set_updated_saveinfo(data)
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

    if not lg.isSupported('canvas') then
        error('Your video card do not support render to texture!')
    end

    if not lg.isSupported('shader') then
        error('Your video car do not support shader!')
    end

    if FIRST_RUN then adjust_screen_mode() end

    return true
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Game.initialize()
    m_saveinfo = {}
end

function Game.finalize()
    Game.system = nil
    -- Game.story = nil
    Game.player = nil

    Game.map = nil
    Game.stage = nil
    Game.script = nil
    Game.message = nil
    m_saveinfo = nil
end

function Game.update(dt)
end

function Game.pause()
end

function Game.resume()
end

function Game.start()
    Data.loadLanguageData(OptionConfigures.language)

    Input.bindKeyEvent('graphics.togglefps', Input.TRIGGER, KEYS.F1, Graphics.toggleFPS)
    Input.bindKeyEvent('gameconsole.toggle', Input.TRIGGER, KEYS.F9, GameConsole.toggle)
    Input.bindKeyEvent('graphics.togglefullscreen', Input.TRIGGER, KEYS.F11, Graphics.toggleFullscreen)
    Input.bindKeyEvent('game.reload', Input.TRIGGER, KEYS.F12, Game.reload)
    Input.bindKeyEvent('game.quit', Input.TRIGGER, KEYS.F4, KEYS.ALTERNATIVE, Game.quit)

    if check_game_requirement() then Scene.goto(SceneTitle.new(DEBUG_MODE)) end
end

function Game.terminate()
end

function Game.setup()
    Game.player = GamePlayer.new()
    -- Game.story = GameStory.new()
    Game.system = GameSystem.new()

    Game.message = GameMessage.new()
    Game.map = GameMap.new()
    Game.stage = GameStage.new()
    Game.script = GameScript.new()

    on_start_game()
end

function Game.load(index)
    local data = Core.load(string.format(SAVING_FILENAME, index))
    set_updated_saveinfo(Core.load(SAVEINFO_FILENAME))

    Game.player = GamePlayer.new(data.player)
    -- Game.story = GameStory.new(data.story)
    Game.system = GameSystem.new(data.system)

    Game.message = GameMessage.new()
    Game.script = GameScript.new()
    Game.stage = GameStage.new()
    Game.map = GameMap.new()

    on_after_load()
    return false
end

function Game.save(index, data)
    on_before_save()

    Core.save(string.format(SAVING_FILENAME, index), data)
    Core.save(SAVEINFO_FILENAME, get_updated_saveinfo())
    return false
end

function Game.delete(index)
    return false
end

function Game.exists()
    for index = 1, SAVING_SLOT_SIZE do
        if lf.exists(string.format(SAVING_FILENAME, index)) then return true end
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

function Game.saveGameConfigure()
    -- Core.save(Systems.paths.configure, Configures, Constants.CONFIGURE_IDENTIFIER)
end

function Game.getVersionString()
    if not m_version then
        m_version = MAJOR .. '.' .. MINOR .. '.' .. MICRO
    end
    return m_version
end

return Game
