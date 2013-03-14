--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-13                                                    ]]--
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

local f_update_coroutine = coroutine.wrap(function(instance, dt, timer)
    --[[
    local chosen

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
    end)]]--

    -- Show main menu
    while not chosen do
        instance.command.update(instance.command, dt)

        coroutine.yield()
    end

    nexus.game.changeScene(nexus.scene.stage.new('prologue'))
end)

local function enter(instance)
    instance.command = nexus.window.command.new(320, 240, {
        {
            text    = 'New Game',
            handler = function(...) end
        }, {
            text    = 'Continue',
            handler = function(...) end
        }, {
            text    = 'Exit',
            handler = function(...)
                love.event.quit()
            end
        }
    })
end

local function leave(instance)
end

local function update(instance, dt)
    f_update_coroutine(instance, dt, love.timer.getMicroTime()) 
end

local function render(instance)
    instance.command.render(instance.command)
end

function nexus.scene.title.new()
    local instance = {
        enter   = enter,
        leave   = leave,
        update  = update, 
        render  = render
    }
    return nexus.scene.new(instance)
end
