--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-14                                                    ]]--
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
nexus.scene.title = {}

local f_update_coroutine = function(instance, dt, timer)
    --[[
    local function wait(microsecond, callback)
        local wakeup = love.timer.getMicroTime() + microsecond / 1000
        repeat callback() until select(2, coroutine.yield()) > wakeup
    end

    -- Show splash screen
    wait(500, function()
    end)

    wait(500, function()
    end)

    wait(500, function()
    end)

    -- Start animation of PRESS TO START message
    wait(500, function()
    end)

    nexus.window.command.open(instnace.command)
    ]]--

    -- Show main menu
    while true do
        nexus.window.update(instance.window.command, dt)
        coroutine.yield()
    end
end

local function enter(instance)
    instance.coroutine.update = coroutine.create(f_update_coroutine)
    instance.window.command = nexus.window.command.new(320, 240, {
        {
            text    = 'New Game',
            handler = function(...)
                nexus.game.changeScene(nexus.scene.stage.new('prologue'))
                -- nexus.game.changeScene(nexus.scene.newgame.new())
            end
        }, {
            text    = 'Continue',
            handler = function(...)
                nexus.game.enterScene(nexus.scene.continue.new())
            end,
            enabled = false
        }, {
            text    = 'Extra',
            handler = function(...)
                nexus.game.enterScene(nexus.scene.extra.new())
            end
        }, {
            text    = 'Option',
            handler = function(...)
                nexus.game.enterScene(nexus.scene.option.new())
            end
        }, {
            text    = 'Exit',
            handler = function(...)
                love.event.quit()
                -- nexus.game.changeScene(nexus.scene.exit.new())
            end
        }
    })
end

local function leave(instance)
    instance.window.command = nil
    instance.coroutine.update = nil
end

local function update(instance, dt)
    if instance.idle then return end

    coroutine.resume(instance.coroutine.update, instance, dt, love.timer.getMicroTime())
end

local function render(instance)
    instance.window.command.render(instance.window.command)
end

function nexus.scene.title.new()
    local instance = {
        enter       = enter,
        leave       = leave,
        update      = update, 
        render      = render,
        window      = {},
        coroutine   = {}
    }
    return nexus.scene.new(instance)
end

