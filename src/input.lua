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

local t_states = {}

local t_controls = nexus.configures.controls

function nexus.input.initialize()
    for k, _ in pairs(t_controls) do
        t_states[k] = {
            press       = false,
            trigger     = false,
            counter     = 0
        }
    end
end

function nexus.input.update()
    for k, t in pairs(t_controls) do
        for _, v in pairs(t) do
            local state = t_states[k]
            if f_isdown(v) then
                if state.press then
                    state.trigger = false
                    state.counter = state.counter + 1
                    if state.counter > 15 then
                        state.counter = 0
                    end
                else
                    state.trigger = true
                end
                state.press = true
            else
                state.press = false
            end
        end
    end
end

function nexus.input.isKeyDown(key)
    local state = t_states[key]
    return state.press 
end

function nexus.input.isKeyUp(key)
    local state = t_states[key]
    return not state.press 
end

function nexus.input.isKeyTrigger(key)
    local state = t_states[key]
    return state.trigger
end

function nexus.input.isKeyRepeat(key)
    local state = t_states[key]
    return state.press and state.counter == 0 
end
