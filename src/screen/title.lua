--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-12                                                    ]]--
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
nexus.screen.title = {}

--[[local m_cursor = 1

local t_menus = {
    'New Game',
    'Continue',
    'Exit'
}]]--

local f_update_coroutine = coroutine.wrap(function(instance, time)
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
        --[[if nexus.input.isKeyRepeat(NEXUS_KEY.UP) then
            m_cursor = m_cursor - 1
            if m_cursor < 1 then
                m_cursor = #t_menus
            end
        end

        if nexus.input.isKeyRepeat(NEXUS_KEY.DOWN) then
            m_cursor = m_cursor + 1
            if m_cursor > #t_menus then
                m_cursor = 1
            end
        end

        if nexus.input.isKeyUp(NEXUS_KEY.C) then
            chosen = m_cursor
        end]]--

        coroutine.yield()
    end

    nexus.game.changeScreen(nexus.screen.stage.new('prologue'))
end)

local function enter(instance)
    local command = nexus.window.command.new(320, 240, {
        {
            text    = 'New Game',
            handler = function(...) end
        }, {
            text    = 'Continue',
            handler = function(...) end
        }, {
            text    = 'Exit',
            handler = function(...) end
        }
    })

    --[[m_cursor = 1]]--
end

local function leave(instance)
end

local function update(instance)
    f_update_coroutine(instance, love.timer.getMicroTime()) 
end

local function draw(instance)
    --[[for index, title in pairs(t_menus) do
        love.graphics.setColor(255, 255, 255)
        if m_cursor == index then
            love.graphics.setColor(255, 255, 0)
        end
        love.graphics.print(tostring(title), 120, 480 + index * 20)
    end]]--
end

function nexus.screen.title.new()
    local instance = {
        enter   = enter,
        leave   = leave,
        update  = update, 
        draw    = draw
    }
    return nexus.screen.new(instance)
end
