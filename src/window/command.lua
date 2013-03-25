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
nexus.window.command        = {
    size                    = 0,
    cursor                  = 1,
    commands                = {}
}

-- / ---------------------------------------------------------------------- \ --
-- | Import modules                                                         | --
-- \ ---------------------------------------------------------------------- / --
local l                     = love
local lg                    = l.graphics
local require               = require
local Nexus                 = nexus
local Core                  = Nexus.core
local Base                  = Nexus.base
local Input                 = Core.input or require 'src.core.input'
local WindowBase            = Base.window or require 'src.base.window'
local NEXUS_KEY             = NEXUS_KEY
local NEXUS_EMPTY_FUNCTION  = NEXUS_EMPTY_FUNCTION

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local WindowCommand         = nexus.window.command 

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function move_cursor_up(instance, wrap)
    instance.cursor = instance.cursor - 1
    if instance.cursor < 1 then
        instance.cursor = wrap and instance.size or 1 
    end
end

local function move_cursor_down(instance, wrap)
    instance.cursor = instance.cursor + 1
    if instance.cursor > instance.size then
        instance.cursor = wrap and 1 or instance.size
    end
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function WindowCommand.new(x, y, commands)
    local instance = WindowBase.new(WindowCommand)
    instance.x = x or instance.x
    instance.y = y or instance.y
    if commands then WindowCommand.addCommands(instance, commands) end
    return instance
end

function WindowCommand.update(instance, dt)
    if Input.isKeyRepeat(NEXUS_KEY.UP) then
        move_cursor_up(instance, Input.isKeyTrigger(NEXUS_KEY.UP))
    end

    if Input.isKeyRepeat(NEXUS_KEY.DOWN) then
        move_cursor_down(instance, Input.isKeyTrigger(NEXUS_KEY.DOWN))
    end

    if Input.isKeyDown(NEXUS_KEY.C) then
        local command = instance.commands[instance.cursor]
        if command.enabled then command.handler() end
        return instance.cursor 
    end
end

function WindowCommand.render(instance)
    for index, command in ipairs(instance.commands) do
        if command.enabled then
            lg.setColor(255, 255, 255)
        else
            lg.setColor(255, 255, 255, 128)
        end
        if instance.cursor == index then
            lg.setColor(255, 255, 0)
        end
        lg.print(command.text, instance.x, instance.y + index * 20) 
    end
end

function WindowCommand.setHandler(instance, text, handler)
    for _, command in ipairs(instance.commands) do
        if command.text == text then
            command.handler = handler
            return true
        end
    end
    return false
end

function WindowCommand.addCommand(instance, text, enabled, handler)
    assert(type(text) == 'string')

    instance.size = instance.size + 1
    instance.commands[instance.size] = {
        text    = text,
        enabled = enabled == nil or true and false,
        handler = handler or NEXUS_EMPTY_FUNCTION
    }
end

function WindowCommand.addCommands(instance, commands)
    assert(type(commands) == 'table')

    for _, command in pairs(commands) do
        instance.addCommand(instance, command.text, command.enabled, command.handler)
    end
end

return WindowCommand
