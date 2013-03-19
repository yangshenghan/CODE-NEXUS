--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-19                                                    ]]--
--[[ License: zlib/libpng License                                           ]]--
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
    --[[
    local wait = function(microsecond, callback)
        local wakeup = love.timer.getMicroTime() + microsecond / 1000
        repeat callback() until select(2, coroutine.yield()) > wakeup
    end

    -- Show splash screen
    if not instance.skip then
        wait(500, function()
        end)

        wait(500, function()
        end)

        wait(500, function()
        end)
    end

    -- Start animation of PRESS TO START message
    wait(500, function()
    end)

    nexus.window.command.open(instnace.command)
    ]]--

    -- Show main menu
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
    nexus.base.window.dispose(instance.windows.command)

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
