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
nexus.input = {}

local f_isdown = love.keyboard.isDown

local t_pressed = {}

local t_released = {}

local t_triggered = {}

local t_counter = {}

local t_controls = nexus.configures.controls

function nexus.input.initialize()
    for key, _ in pairs(t_controls) do
        t_pressed[key] = false
        t_released[key] = false
        t_triggered[key] = false
        t_counter[key] = 0
    end
end

function nexus.input.update()
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

