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
local Data                  = Core.require 'src.core.data'
local Game                  = Core.require 'src.core.game'
local Graphics              = Core.require 'src.core.graphics'
local Input                 = Core.require 'src.core.input'
local Resource              = Core.require 'src.core.resource'
local Scene                 = Core.require 'src.core.scene'
local SpriteBase            = Core.require 'src.sprite.base'
local SceneBase             = Core.require 'src.scene.base'
local SceneStage            = Core.require 'src.scene.stage'
-- local SceneNewGame          = Core.require 'src.scene.newgame'
local SceneContinue         = Core.require 'src.scene.continue'
local SceneExtra            = Core.require 'src.scene.extra'
local SceneOption           = Core.require 'src.scene.option'
local SceneExit             = Core.require 'src.scene.exit'
local WindowCommand         = Core.require 'src.window.command'
local NEXUS_KEY             = Constants.KEYS

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
local function title_update_coroutine(instance, dt, timer)
    local wait = function(microsecond, callback)
        local wakeup = lt.getMicroTime() + microsecond / 1000
        repeat callback(dt) until select(3, coroutine.yield()) > wakeup
    end

    -- Show splash screens
    if not instance.skip then
        local splash = SpriteBase.new({}, Graphics.getWindowViewport())
        splash.x = Graphics.getScreenWidth() / 2
        splash.y = Graphics.getScreenHeight() / 2
        splash.setImage(splash, Resource.loadSystemImage('splash1.png'))
        splash.opacity = 0
        wait(1000, function(dt)
            splash.opacity = splash.opacity + dt
        end)

        wait(1000, function() end)

        wait(1000, function(dt)
            splash.opacity = splash.opacity - dt
        end)
        splash.dispose(splash)
    end

    -- Start animation of PRESS TO START message
    local waiting = SpriteBase.new({}, Graphics.getWindowViewport())
    waiting.x = Graphics.getScreenWidth() / 2
    waiting.y = Graphics.getScreenHeight() / 2
    waiting.setImage(waiting, Resource.loadSystemImage('press_any_key_to_continue.png'))
    while true do
        local cycle, phase = math.modf((timer - 0.5) / 0.75)
        if Input.isKeyTrigger(NEXUS_KEY.C) then break end
        if cycle % 2 == 0 then
            waiting.opacity = 1 - phase
        else
            waiting.opacity = phase
        end
        timer = select(3, coroutine.yield())
    end
    waiting.dispose(waiting)

    while waiting.opacity < 1 do
        waiting.opacity = waiting.opacity + dt
        coroutine.yield()
    end
    wait(100, function() end)

    -- Show main menu
    instance.windows.command.open(instance.windows.command)
    while true do
        instance.windows.command.update(instance.windows.command, dt)
        coroutine.yield()
    end
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
            text    = Data.getTranslatedText('New Game'),
            handler = function(...)
                Game.setup()
                Scene.goto(SceneStage.new('prologue'))
                -- Scene.goto(SceneNewGame.new())
            end
        }, {
            text    = Data.getTranslatedText('Continue'),
            handler = function(...)
                Scene.goto(SceneContinue.new())
            end,
            enabled = Game.exists()
        }, {
            text    = Data.getTranslatedText('Extra'),
            handler = function(...)
                Scene.goto(SceneExtra.new())
            end
        }, {
            text    = Data.getTranslatedText('Option'),
            handler = function(...)
                Scene.goto(SceneOption.new())
            end
        }, {
            text    = Data.getTranslatedText('Exit'),
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

    coroutine.resume(instance.coroutines.update, instance, dt, lt.getMicroTime())
end

return SceneTitle
