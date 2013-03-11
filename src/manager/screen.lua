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
nexus.manager.screen = {}

local current = nil

local screens = {}

function nexus.manager.screen.initialize()
end

function nexus.manager.screen.change(screen)
    if current then
        current.leave(current)
    end
    current = screen
    if current then
        current.enter(current)
    end
end

function nexus.manager.screen.push(screen)
    if #screens > 0 then
        local last = table.last(screens)
        nexus.screen.setIdle(last, true)
        last.idleIn(last)
    elseif current then
        nexus.screen.setIdle(current, true)
        current.idleIn(current)
    end

    table.insert(screens, screen)
    screen.enter(screen)
end

function nexus.manager.screen.pop()
    if #screens == 0 then
        return
    end

    local popped = table.remove(screens)
    popped.leave(popped)

    if #screens > 0 then
        local last = table.last(screens)
        nexus.screen.setIdle(last, false)
        last.idleOut(last)
    elseif current then
        nexus.screen.setIdle(current, false)
        current.idleOut(current)
    end
end

function nexus.manager.screen.update(...)
    if current then
        current.update(current, ...)
    end

    for _, screen in ipairs(screens) do
        if not screen.idle then
            screen.update(screen, ...)
        end
    end
end

function nexus.manager.screen.draw(...)
    if current then
        current.draw(current, ...)
    end

    for _, screen in ipairs(screens) do
        screen.draw(screen, ...)
    end
end
