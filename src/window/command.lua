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

-- / ---------------------------------------------------------------------- \ --
-- | Import modules                                                         | --
-- \ ---------------------------------------------------------------------- / --
local l                     = love
local lg                    = l.graphics
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Data                  = Core.import 'nexus.core.data'
local Input                 = Core.import 'nexus.core.input'
local Color                 = Core.import 'nexus.base.color'
local Font                  = Core.import 'nexus.base.font'
local WindowBase            = Core.import 'nexus.window.base'
local KEYS                  = Constants.KEYS
local EMPTY_FUNCTION        = Constants.EMPTY_FUNCTION

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local WindowCommand         = {
    font                    = nil,
    size                    = 0,
    cursor                  = 1,
    commands                = {}
}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local t_default_color       = Color.new(255, 255, 255, 255)
local t_disabled_color      = Color.new(255, 255, 255, 128)
local t_selected_color      = Color.new(255, 255, 0, 255)

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
    instance.font = Data.getFont('message')
    if commands then WindowCommand.addCommands(instance, commands) end
    return instance
end

function WindowCommand.update(instance, dt)
    WindowBase.beforeUpdate(instance, dt)
    if Input.isKeyRepeat(KEYS.UP) then
        move_cursor_up(instance, Input.isKeyTrigger(KEYS.UP))
    end

    if Input.isKeyRepeat(KEYS.DOWN) then
        move_cursor_down(instance, Input.isKeyTrigger(KEYS.DOWN))
    end

    if Input.isKeyTrigger(KEYS.C) then
        local command = instance.commands[instance.cursor]
        if command.enabled then command.handler() end
        return instance.cursor
    end
    WindowBase.afterUpdate(instance, dt)
end

function WindowCommand.render(instance)
    WindowBase.beforeRender(instance)
    for index, command in ipairs(instance.commands) do
        if command.enabled then
            instance.font.color = t_default_color
        else
            instance.font.color = t_disabled_color
        end
        if instance.cursor == index then
            instance.font.color = t_selected_color
        end
        Font.text(instance.font, command.text, instance.x, instance.y + index * 32)
    end
    WindowBase.afterRender(instance)
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
        handler = handler or EMPTY_FUNCTION
    }
end

function WindowCommand.addCommands(instance, commands)
    assert(type(commands) == 'table')

    for _, command in pairs(commands) do
        instance.addCommand(instance, command.text, command.enabled, command.handler)
    end
end

return WindowCommand
