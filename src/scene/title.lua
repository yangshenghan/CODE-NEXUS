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
local nexus = nexus

nexus.scene.title = {}

local f_update_coroutine = function(instance, dt, timer)
    local wait = function(microsecond, callback)
        local wakeup = love.timer.getMicroTime() + microsecond / 1000
        repeat callback(dt) until select(3, coroutine.yield()) > wakeup
    end

    -- Show splash screens
    if not instance.skip then
        local splash = nexus.base.sprite.new({
            x       = nexus.configures.graphics.width / 2,
            y       = nexus.configures.graphics.height / 2
        }, nexus.core.graphics.getWindowViewport())
        nexus.base.sprite.setImage(splash, nexus.core.resource.loadSystemImage('splash1.png'))
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
        x       = nexus.configures.graphics.width / 2,
        y       = nexus.configures.graphics.height / 2
    }, nexus.core.graphics.getWindowViewport())
    nexus.base.sprite.setImage(waiting, nexus.core.resource.loadSystemImage('press_any_key_to_continue.png'))
    while true do
        local cycle, phase = math.modf((timer - 0.5) / 0.75)
        if nexus.core.input.isKeyTrigger(NEXUS_KEY.C) then break end
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
        nexus.base.window.update(instance.windows.command, dt)
        coroutine.yield()
    end
end

local function enter(instance)
    instance.coroutines.update = coroutine.create(f_update_coroutine)
    instance.windows.command = nexus.window.command.new(320, 240, {
        {
            text    = nexus.core.database.getTranslatedText('New Game'),
            handler = function(...)
                nexus.data.setup()
                nexus.core.scene.goto(nexus.scene.stage.new('prologue'))
                -- nexus.core.scene.goto(nexus.scene.newgame.new())
            end
        }, {
            text    = nexus.core.database.getTranslatedText('Continue'),
            handler = function(...)
                nexus.core.scene.goto(nexus.scene.continue.new())
            end,
            enabled = nexus.data.exists()
        }, {
            text    = nexus.core.database.getTranslatedText('Extra'),
            handler = function(...)
                nexus.core.scene.goto(nexus.scene.extra.new())
            end
        }, {
            text    = nexus.core.database.getTranslatedText('Option'),
            handler = function(...)
                nexus.core.scene.goto(nexus.scene.option.new())
            end
        }, {
            text    = nexus.core.database.getTranslatedText('Exit'),
            handler = function(...)
                nexus.core.scene.goto(nexus.scene.exit.new())
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
