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
local type                  = type
local pairs                 = pairs
local error                 = error
local table                 = table
local tostring              = tostring
local coroutine             = coroutine
local setmetatable          = setmetatable
local getmetatable          = getmetatable
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Configures            = Nexus.configures
local VERSION               = Constants.VERSION
local DEBUG_MODE            = Constants.DEBUG_MODE
local EMPTY_FUNCTION        = Constants.EMPTY_FUNCTION

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local f_coroutine_resume    = coroutine.resume

-- / ---------------------------------------------------------------------- \ --
-- | Extend bulit-in lua modules and functions                              | --
-- \ ---------------------------------------------------------------------- / --
function table.first(t)
    return t[1]
end

function table.last(t)
    return t[#t]
end

function table.indexOf(t, v)
    for key, value in pairs(t) do
        if type(v) == 'function' then
            if v(value) then return key end
        else
            if value == v then return key end
        end
    end

    return nil
end

function table.removeValue(t, v)
    local index = table.indexOf(t, v)
    if index then table.remove(t, index) end
    return t
end

function coroutine.resume(...)
    local success, result = f_coroutine_resume(...)
    if not success then error(tostring(result), 2) end
    return success, result
end

-- / ---------------------------------------------------------------------- \ --
-- | Debug functions                                                        | --
-- \ ---------------------------------------------------------------------- / --
if DEBUG_MODE then

local Game                  = nil
local Graphics              = nil
local Scene                 = nil
local GameConsole           = nil

local lggm                  = nil
local lgsm                  = nil
local update                = nil
local render                = nil

return function(instance, enable)
    -- / ------------------------------------------------------------------ \ --
    -- | Import modules                                                     | --
    -- \ ------------------------------------------------------------------ / --
    local l                     = love
    local lt                    = l.timer
    local lg                    = l.graphics
    Game                    = Core.import 'nexus.core.game'
    Graphics                = Core.import 'nexus.core.graphics'
    Scene                   = Core.import 'nexus.core.scene'
    GameConsole             = Core.import 'nexus.game.console'

    -- / ------------------------------------------------------------------ \ --
    -- | Declare object                                                     | --
    -- \ ------------------------------------------------------------------ / --
    local Debug             = {}

    -- / ------------------------------------------------------------------ \ --
    -- | Local variables                                                    | --
    -- \ ------------------------------------------------------------------ / --
    local m_x_offset        = 8
    local m_y_offset        = 8
    local m_line_height     = 24

    -- / ------------------------------------------------------------------ \ --
    -- | Member functions                                                   | --
    -- \ ------------------------------------------------------------------ / --
    function Debug.profiler()
    end

    if not enable then
        lg.getMode = lggm
        lg.setMode = lgsm
        Scene.update = update
        Graphics.render = render
        return EMPTY_FUNCTION
    end

    -- / ------------------------------------------------------------------ \ --
    -- | Game hooks in debug mode                                           | --
    -- \ ------------------------------------------------------------------ / --
    lggm                    = lg.getMode
    lgsm                    = lg.setMode
    update                  = Scene.update
    render                  = Graphics.render

    if l._version ~= '0.9.0' then
        function lg.setDefaultFilter(...)
            return lg.setDefaultImageFilter(...)
        end

        function lg.getMode()
            local width, height, fullscreen, vsync, fsaa = lggm()
            return width, height, {
                fullscreen  = fullscreen,
                vsync       = vsync,
                fsaa        = fsaa,
                resizeable  = false,
                borderless  = false,
                centered    = true
            }
        end

        function lg.setMode(width, height, flags)
            lgsm(width, height, flags.fullscreen, flags.vsync, flags.fsaa)
        end
    end

    function Scene.update(...)
        update(...)
    end

    function Graphics.render(...)
        local width, height, flags = lg.getMode()

        render(...)

        if not GameConsole.isConsoleEnabled() then
            lg.setColor(255, 255, 255, 255)
            lg.printf(string.format('FPS: %d', lt.getFPS()), m_x_offset, m_y_offset, width, 'left')
            lg.printf(string.format('Lua Memory Usage: %d KB', collectgarbage('count')), m_x_offset, m_y_offset + m_line_height, width, 'left')
            lg.printf(string.format('Screen: %d x %d (%s, vsync %s, fsaa %d)', width, height, flags.fullscreen and 'fullscreen' or 'windowed', flags.vsync and 'enabled' or 'disabled', flags.fsaa), m_x_offset, m_y_offset + 2 * m_line_height, width, 'left')
            lg.printf(string.format('Date: %s', os.date()), m_x_offset, m_y_offset + 3 * m_line_height, width, 'left')

            lg.printf(string.format('NOT FINAL GAME'), 0, 60, width, 'center')
            lg.printf(string.format('CODE NEXUS %s (%s) on %s.', Game.getVersionString(), VERSION.STAGE, l._os), 0, height - 24, width - 8, 'right')
        end
    end

    return Debug
end

end

return function()
    return setmetatable({}, {
        __index             = EMPTY_FUNCTION
    })
end
