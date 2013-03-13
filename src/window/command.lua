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
nexus.window.command = {}

local function update(instance)
    if nexus.input.isKeyRepeat(NEXUS_KEY.UP) then
        instance.cursor = instance.cursor - 1
        if instance.cursor < 1 then
            instance.cursor = instance.size 
        end
    end

    if nexus.input.isKeyRepeat(NEXUS_KEY.DOWN) then
        instance.cursor = instance.cursor + 1
        if instance.cursor > instance.size then
            instance.cursor = 1
        end
    end
end

local function draw(instance)
    local index = 0
    for _, command in pairs(instance.commands) do
        love.graphics.setColor(255, 255, 255)
        if instance.cursor == index + 1 then
            love.graphics.setColor(255, 255, 0)
        end
        love.graphics.print(command.text, instance.x, instance.y + index * 20) 
        index = index + 1
    end
end

function nexus.window.command.setHandler(instance, text, handler)
    local command = instance.commands[text]
    command.handler = handler
end

function nexus.window.command.addCommand(instance, text, enabled)
    assert(type(text) == 'string')

    instance.size = instance.size + 1
    instance.commands[text] = {
        text    = text,
        enabled = enabled,
        handler = function(...) end
    }
end

function nexus.window.command.addCommands(instance, commands)
    assert(type(commands) == 'table')

    for _, command in pairs(commands) do
        nexus.window.command.addCommand(instance, command.text, command.enabled)
        if command.handler then
            nexus.window.command.setHandler(instance, command.text, command.handler)
        end
    end
end

function nexus.window.command.new(x, y, commands)
    local instance = {
        x               = x,
        y               = y,
        size            = 0,
        cursor          = 1,
        commands        = {}
    }
    if commands then
        nexus.window.command.addCommands(instance, commands)
    end
    instance.update = update
    instance.draw = draw
    return nexus.window.new(instance)
end

