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
local lt                    = l.timer
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Data                  = Core.import 'nexus.core.data'
local Game                  = Core.import 'nexus.core.game'
local Graphics              = Core.import 'nexus.core.graphics'
local Input                 = Core.import 'nexus.core.input'
local Resource              = Core.import 'nexus.core.resource'
local Scene                 = Core.import 'nexus.core.scene'
local SpritePicture         = Core.import 'nexus.sprite.picture'
local SceneBase             = Core.import 'nexus.scene.base'
local SceneNewGame          = Core.import 'nexus.scene.newgame'
local SceneContinue         = Core.import 'nexus.scene.continue'
local SceneExtra            = Core.import 'nexus.scene.extra'
local SceneOption           = Core.import 'nexus.scene.option'
local SceneExit             = Core.import 'nexus.scene.exit'
local WindowCommand         = Core.import 'nexus.window.command'
local KEYS                  = Constants.KEYS
local EMPTY_FUNCTION        = Constants.EMPTY_FUNCTION
local REFERENCE_WIDTH       = Constants.REFERENCE_WIDTH
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SceneTitle            = {
    windows                 = nil,
    coroutines              = nil,
    skip                    = false
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function wait(microsecond, callback)
    local wakeup = lt.getMicroTime() + microsecond / 1000
    repeat callback(select(2, coroutine.yield())) until lt.getMicroTime() > wakeup
end

local function display_splash_screen(filename)
    local splash = SpritePicture.new(nil, filename)
    splash.opacity = 0
    splash.update(splash)
    wait(1000, function(dt) splash.opacity = splash.opacity + dt splash.update(splash) end)
    wait(1000, function(dt) splash.update(splash) end)
    wait(1000, function(dt) splash.opacity = splash.opacity - dt splash.update(splash) end)
    splash.dispose(splash)
end

local function display_waiting_message()
    local delta = 0
    local waiting = SpritePicture.new(nil, Data.getSystem('waiting_any_key'))
    waiting.update(waiting)

    while true do
        local cycle, phase = math.modf((lt.getMicroTime() - 0.5) / 0.75)
        if Input.isKeyTrigger(KEYS.C) then break end
        if cycle % 2 == 0 then
            waiting.opacity = 1 - phase
        else
            waiting.opacity = phase
        end
        waiting.update(waiting)
        coroutine.yield()
    end

    delta = (1 - waiting.opacity) * 300
    while waiting.opacity < 1 do
        waiting.opacity = waiting.opacity + delta
        waiting.update(waiting)
        coroutine.yield()
    end
    waiting.dispose(waiting)
end

local function display_title_menu(command)
    command.open(command)

    while true do
        command.update(command, dt)
        coroutine.yield()
    end
end

local function title_update_coroutine(instance, dt)
    local splashs = {
        Data.getSystem('splash1'),
        Data.getSystem('splash2'),
        Data.getSystem('splash3')
    }

    -- Show splash screens
    if not instance.skip then
        for _, splash in ipairs(splashs) do display_splash_screen(splash) end
    end
    SceneTitle.skip = true

    -- Start animation of PRESS TO START message
    display_waiting_message()

    -- Show main menu
    display_title_menu(instance.windows.command, dt)
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SceneTitle.new(skip)
    local instance = SceneBase.new(SceneTitle)
    instance.skip = skip or instance.skip
    instance.windows = {}
    instance.coroutines = {}
    return instance
end

function SceneTitle.enter(instance)
    instance.coroutines.update = coroutine.create(title_update_coroutine)
    instance.windows.command = WindowCommand.new(320, 240, {
        {
            text    = Data.getText('New Game'),
            handler = function(...)
                Scene.goto(SceneNewGame.new())
            end
        }, {
            text    = Data.getText('Continue'),
            handler = function(...)
                Scene.goto(SceneContinue.new())
            end,
            enabled = Game.exists()
        }, {
            text    = Data.getText('Extra'),
            handler = function(...)
                Scene.goto(SceneExtra.new())
            end
        }, {
            text    = Data.getText('Option'),
            handler = function(...)
                Scene.goto(SceneOption.new())
            end
        }, {
            text    = Data.getText('Exit'),
            handler = function(...)
                Scene.goto(SceneExit.new())
            end
        }
    })
end

function SceneTitle.leave(instance)
    instance.windows.command.dispose(instance.windows.command)

    instance.windows.command = nil
    instance.coroutines.update = nil
end

function SceneTitle.update(instance, dt)
    if instance.idle then return end

    coroutine.resume(instance.coroutines.update, instance, dt)
end

function SceneTitle.__debug(instance)
    return {
        'SeceneTitle',
        'Nothing to show.'
    }
end

return SceneTitle
