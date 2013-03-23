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
local l             = love
local lm            = l.mouse
local lk            = l.keyboard

local Nexus         = nexus
local NexusCore     = Nexus.core

local Game          = require 'src.core.game'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
NexusCore.input     = {}

local Input         = NexusCore.input

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_system_f1   = false

local m_system_f9   = false

local m_system_f12  = false

local t_pressed     = {}

local t_released    = {}

local t_triggered   = {}

local t_counter     = {}

local t_controls    = nexus.configures.controls

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
    m_system_f1 = false
    m_system_f9 = false
    m_system_f12 = false
end

function Input.update(dt)
    for key, keys in pairs(t_controls) do
        for _, keycode in pairs(keys) do
            if lk.isDown(keycode) then
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
            end
        end
    end

    if lk.isDown('f1') then
        if not m_system_f1 then
            m_system_f1 = true
            nexus.core.graphics.toggleFPS()
        end
    else
        m_system_f1 = false
    end

    if lk.isDown('f9') then
        if not m_system_f9 then
            m_system_f9 = true
            nexus.console.toggleConsole()
        end
    else
        m_system_f9 = false
    end

    if lk.isDown('f12') then
        if not m_system_f12 then
            m_system_f12 = true
            Game.reload()
        end
    else
        m_system_f12 = false
    end

    if lk.isDown('lalt') or lk.isDown('ralt') then
        if lk.isDown('f4') then Game.quit() end
        if lk.isDown('return') then nexus.core.graphics.toggleFullscreen() end
    end
end

function Input.pause()
end

function Input.resume()
end

function Input.reload()
end

-- function Input.changeInputConfigures()
    -- nexus.game.saveGameConfigure()
-- end

function Input.isKeyDown(key)
    return t_pressed[key] 
end

function Input.isKeyUp(key)
    return t_released[key]
end

function Input.isKeyTrigger(key)
    return t_triggered[key]
end

function Input.isKeyRepeat(key)
    return t_pressed[key] and t_counter[key] == 0
end

return Input
