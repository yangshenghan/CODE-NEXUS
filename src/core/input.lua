--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-16                                                    ]]--
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
nexus.input = {}

local m_system_f1 = false

local m_system_f4 = false

local m_system_f12 = false

local f_isdown = love.keyboard.isDown

local t_pressed = {}

local t_released = {}

local t_triggered = {}

local t_counter = {}

local t_controls = nexus.configures.controls

function nexus.input.initialize()
    -- love.mouse.setGrab(true)
    love.mouse.setVisible(false)

    nexus.input.reload()

    for key, _ in pairs(t_controls) do
        t_pressed[key] = false
        t_released[key] = false
        t_triggered[key] = false
        t_counter[key] = 0
    end
end

function nexus.input.finalize()
    love.mouse.setVisible(true)
    love.mouse.setGrab(false)

    nexus.input.clear()
end

function nexus.input.update(dt)
    for key, keys in pairs(t_controls) do
        for _, keycode in pairs(keys) do
            if f_isdown(keycode) then
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

    if f_isdown('f1') then
        if not m_system_f1 then
            m_system_f1 = true
            nexus.graphics.toggleFPS()
        end
    else
        m_system_f1 = false
    end

    if f_isdown('f4') then
        if not m_system_f4 then
            m_system_f4 = true
            nexus.settings.console = not nexus.settings.console
        end
    else
        m_system_f4 = false
    end

    if f_isdown('f12') then
        if not m_system_f12 then
            m_system_f12 = true
            nexus.game.reload()
        end
    else
        m_system_f12 = false
    end

    if f_isdown('lalt') or f_isdown('ralt') then
        if f_isdown('f4') then love.event.quit() end
        if f_isdown('return') then nexus.graphics.toggleFullscreen() end
    end
end

function nexus.input.pause()
end

function nexus.input.resume()
end

function nexus.input.reload()
end

function nexus.input.clear()
    t_counter = {}
    t_triggered = {}
    t_released = {}
    t_pressed = {}
    m_system_f1 = false
    m_system_f4 = false
    m_system_f12 = false
end

function nexus.input.changeInputConfigures()
    nexus.game.saveGameConfigure()
end

function nexus.input.isKeyDown(key)
    return t_pressed[key] 
end

function nexus.input.isKeyUp(key)
    return t_released[key]
end

function nexus.input.isKeyTrigger(key)
    return t_triggered[key]
end

function nexus.input.isKeyRepeat(key)
    return t_pressed[key] and t_counter[key] == 0
end
