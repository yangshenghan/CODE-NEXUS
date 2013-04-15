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
local pairs                 = pairs
local unpack                = unpack
local collectgarbage        = collectgarbage
local l                     = love
local lm                    = l.mouse
local lk                    = l.keyboard
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Configures            = Nexus.configures
local MouseConfigures       = Configures.mouses
local KeyboardConfigures    = Configures.keyboards
-- local JoystickConfigures    = Configures.joysticks

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Input                 = {
    PRESS                   = 'press',
    REPEAT                  = 'repeat',
    RELEASE                 = 'release',
    TRIGGER                 = 'trigger'
}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local t_events              = {}

local t_pressed             = {}

local t_released            = {}

local t_triggered           = {}

local t_counter             = {}

local t_controls            = KeyboardConfigures

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function check_modifier_pressed(modifiers)
    if modifiers then return t_pressed[modifiers] end
    return true
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Input.initialize()
    -- lm.setGrab(true)
    lm.setVisible(false)

    Input.reload()

    for key, _ in pairs(t_controls) do
        t_pressed[key] = false
        t_released[key] = false
        t_triggered[key] = false
        t_counter[key] = 0
    end
end

function Input.finalize()
    lm.setVisible(true)
    lm.setGrab(false)

    Input.reset()
end

function Input.reset()
    t_counter = {}
    t_triggered = {}
    t_released = {}
    t_pressed = {}
    t_events = {}
    collectgarbage()
end

function Input.update(dt)
    for key, keys in pairs(t_controls) do
        if lk.isDown(unpack(keys)) then
            if t_pressed[key] then
                t_triggered[key] = false
                t_counter[key] = t_counter[key] + 1
                if t_counter[key] > 15 then
                    t_counter[key] = 0
                end
            else
                t_triggered[key] = true
            end
            t_pressed[key] = true
            t_released[key] = false
        else
            if t_pressed[key] then
                t_counter[key] = 0
                t_released[key] = true
            end
            t_pressed[key] = false
            t_triggered[key] = false
        end
    end

    for name, event in pairs(t_events) do
        local t, k, m, f = unpack(event)
        if t == Input.PRESS and Input.isKeyDown(k, m) or t == Input.REPEAT and Input.isKeyRepeat(k, m) or t == Input.RELEASE and Input.isKeyUp(k, m) or t == Input.TRIGGER and Input.isKeyTrigger(k, m) then f() end
    end
end

function Input.pause()
end

function Input.resume()
end

function Input.reload()
end

function Input.bindKeyEvent(name, ...)
    local args = {...}

    if #args == 4 then
        t_events[name] = {args[1], args[2], args[3], args[4]}
    else
        t_events[name] = {args[1], args[2], nil, args[3]}
    end
end

function Input.bindKeyEvents(events)
    for name, event in pairs(events) do Input.bindKeyEvent(name, unpack(event)) end
end

function Input.unbindKeyEvent(name)
    t_events[name] = nil
end

function Input.unbindKeyEvents(names)
    for _, name in pairs(names) do Input.unbindKeyEvent(name) end
end

function Input.isKeyDown(key, modifiers)
    return t_pressed[key] and check_modifier_pressed(modifiers)
end

function Input.isKeyUp(key)
    return t_released[key]
end

function Input.isKeyTrigger(key, modifiers)
    return t_triggered[key] and check_modifier_pressed(modifiers)
end

function Input.isKeyRepeat(key, modifiers)
    return t_pressed[key] and t_counter[key] == 0 and check_modifier_pressed(modifiers)
end

return Input
