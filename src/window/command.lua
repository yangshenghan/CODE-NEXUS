--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-20                                                    ]]--
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

nexus.window.command = {}

local function update(instance, dt)
    if nexus.core.input.isKeyRepeat(NEXUS_KEY.UP) then
        nexus.window.command.moveCursorUp(instance, nexus.core.input.isKeyTrigger(NEXUS_KEY.UP))
    end

    if nexus.core.input.isKeyRepeat(NEXUS_KEY.DOWN) then
        nexus.window.command.moveCursorDown(instance, nexus.core.input.isKeyTrigger(NEXUS_KEY.DOWN))
    end

    if nexus.core.input.isKeyDown(NEXUS_KEY.C) then
        local command = instance.commands[instance.cursor]
        if command.enabled then command.handler() end
        return instance.cursor 
    end
end

local function render(instance)
    for index, command in ipairs(instance.commands) do
        if command.enabled then
            love.graphics.setColor(255, 255, 255)
        else
            love.graphics.setColor(255, 255, 255, 128)
        end
        if instance.cursor == index then
            love.graphics.setColor(255, 255, 0)
        end
        love.graphics.print(command.text, instance.x, instance.y + index * 20) 
    end
end

function nexus.window.command.moveCursorUp(instance, wrap)
    instance.cursor = instance.cursor - 1
    if instance.cursor < 1 then
        instance.cursor = wrap and instance.size or 1 
    end
end

function nexus.window.command.moveCursorDown(instance, wrap)
    instance.cursor = instance.cursor + 1
    if instance.cursor > instance.size then
        instance.cursor = wrap and 1 or instance.size
    end
end

function nexus.window.command.setHandler(instance, text, handler)
    for _, command in ipairs(instance.commands) do
        if command.text == text then
            command.handler = handler
            return true
        end
    end
    return false
end

function nexus.window.command.addCommand(instance, text, enabled, handler)
    assert(type(text) == 'string')

    instance.size = instance.size + 1
    instance.commands[instance.size] = {
        text    = text,
        enabled = enabled == nil or true and false,
        handler = handler or function(...) end
    }
end

function nexus.window.command.addCommands(instance, commands)
    assert(type(commands) == 'table')

    for _, command in pairs(commands) do
        nexus.window.command.addCommand(instance, command.text, command.enabled, command.handler)
    end
end

function nexus.window.command.new(x, y, commands)
    return nexus.base.window.new({
        create      = function(instance)
            if commands then
                nexus.window.command.addCommands(instance, commands)
            end
        end,
        update      = update,
        render      = render,
        x           = x,
        y           = y,
        size        = 0,
        cursor      = 1,
        commands    = {}
    })
end
