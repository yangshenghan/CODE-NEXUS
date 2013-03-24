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
local nexus                 = nexus

nexus.scene.title           = {}

local require               = require

local Nexus                 = nexus
local Configures            = Nexus.configures
local GraphicsConfigures    = Configures.graphics

local Data                  = require 'src.core.data'
local Game                  = require 'src.core.game'
local Graphics              = require 'src.core.graphics'
local Input                 = require 'src.core.input'
local Resource              = require 'src.core.resource'
local Scene                 = require 'src.core.scene'

local CommandWindow         = require 'src.window.command'

local NEXUS_KEY             = NEXUS_KEY

local f_update_coroutine = function(instance, dt, timer)
    local wait = function(microsecond, callback)
        local wakeup = love.timer.getMicroTime() + microsecond / 1000
        repeat callback(dt) until select(3, coroutine.yield()) > wakeup
    end

    -- Show splash screens
    if not instance.skip then
        local splash = nexus.base.sprite.new({
            x       = GraphicsConfigures.width / 2,
            y       = GraphicsConfigures.height / 2
        }, Graphics.getWindowViewport())
        nexus.base.sprite.setImage(splash, Resource.loadSystemImage('splash1.png'))
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
    local waiting = nexus.base.sprite.new({
        x       = GraphicsConfigures.width / 2,
        y       = GraphicsConfigures.height / 2
    }, Graphics.getWindowViewport())
    nexus.base.sprite.setImage(waiting, Resource.loadSystemImage('press_any_key_to_continue.png'))
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
    nexus.base.window.open(instance.windows.command)
    while true do
        CommandWindow.update(instance.windows.command, dt)
        coroutine.yield()
    end
end

local function enter(instance)
    instance.coroutines.update = coroutine.create(f_update_coroutine)
    instance.windows.command = CommandWindow.new(320, 240, {
        {
            text    = Data.getTranslatedText('New Game'),
            handler = function(...)
                Game.setup()
                Scene.goto(nexus.scene.stage.new('prologue'))
                -- Scene.goto(nexus.scene.newgame.new())
            end
        }, {
            text    = Data.getTranslatedText('Continue'),
            handler = function(...)
                Scene.goto(nexus.scene.continue.new())
            end,
            enabled = Game.exists()
        }, {
            text    = Data.getTranslatedText('Extra'),
            handler = function(...)
                Scene.goto(nexus.scene.extra.new())
            end
        }, {
            text    = Data.getTranslatedText('Option'),
            handler = function(...)
                Scene.goto(nexus.scene.option.new())
            end
        }, {
            text    = Data.getTranslatedText('Exit'),
            handler = function(...)
                Scene.goto(nexus.scene.exit.new())
            end
        }
    })
end

local function leave(instance)
    instance.windows.command.dispose(instance.windows.command)

    instance.windows.command = nil
    instance.coroutines.update = nil
end

local function update(instance, dt)
    if instance.idle then return end

    coroutine.resume(instance.coroutines.update, instance, dt, love.timer.getMicroTime())
end

function nexus.scene.title.new(skip)
    return nexus.base.scene.new({
        enter       = enter,
        leave       = leave,
        update      = update,
        skip        = skip,
        windows     = {},
        coroutines  = {}
    })
end
