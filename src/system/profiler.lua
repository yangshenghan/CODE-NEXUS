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
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local t_names               = {}

local t_counters            = {}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function hook()
    local func = debug.getinfo(2, 'f').func
    if t_counters[func] == nil then
        t_counters[func] = 1
        t_names[func] = debug.getinfo(2, 'Sn')
    else
        t_counters[func] = t_counters[func] + 1
    end
end

local function get_function_name(func)
    local name = t_names[func]
    local location = string.format('[%s]:%s', name.short_src, name.linedefined)

    if name.what == 'C' then return name.name end
    if name.namewhat ~= '' then
        return string.format('%s (%s)', location, name.name)
    else
        return string.format('%s', location)
    end
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Profiler.start()
    debug.sethook(hook, 'c')
end

function Profiler.stop()
    debug.sethook()
end

function Profiler.report(filename)
    for func, count in pairs(t_counters) do
        print(get_function_name(func), count)
    end
end

return {
    start                   = function()
        debug.sethook(hook, 'c')
    end,
    stop                    = function()
        debug.sethook()
    end,
    report                  = function(filename)
        for func, count in pairs(t_counters) do
            print(get_function_name(func), count)
        end
    end
}
