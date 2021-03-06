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
local os                    = os
local type                  = type
local math                  = math
local pairs                 = pairs
local pcall                 = pcall
local error                 = error
local table                 = table
local ipairs                = ipairs
local string                = string
local unpack                = unpack
local tostring              = tostring
local coroutine             = coroutine
local setmetatable          = setmetatable
local getmetatable          = getmetatable
local collectgarbage        = collectgarbage
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Configures            = Nexus.configures
local KEYS                  = Constants.KEYS
local VERSION               = Constants.VERSION
local DEBUG_MODE            = Constants.DEBUG_MODE
local EMPTY_FUNCTION        = Constants.EMPTY_FUNCTION

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_love_extended       = false

local f_coroutine_resume    = coroutine.resume

-- / ---------------------------------------------------------------------- \ --
-- | Extend bulit-in modules and functions of lua and LÖVE                  | --
-- \ ---------------------------------------------------------------------- / --
function math.clamp(low, n, high)
    return math.min(math.max(n, low), high)
end

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
    local results = { f_coroutine_resume(...) }
    if not results[1] then error(tostring(results[2]), 2) end
    return unpack(results)
end

function extend_love_functions()
    if not m_love_extended then
        local l                 = love
        local lf                = l.filesystem

        local lfload            = lf.load

        function lf.loadChunk(path)
            return lfload(path)
        end

        function lf.load(path, failed)
            local ok
            local chunk
            local result

            if not failed then failed = error end

            ok, chunk = pcall(lfload, path)
            if not ok then
                failed(tostring(chunk))
            else
                ok, result = pcall(chunk)
                if not ok then failed(tostring(result)) end
            end

            return result
        end

        m_love_extended = true
    end
end

-- / ---------------------------------------------------------------------- \ --
-- | Debug functions                                                        | --
-- \ ---------------------------------------------------------------------- / --
if DEBUG_MODE then

local lggm                  = nil
local lgsm                  = nil
local sc                    = nil
local sg                    = nil
local se                    = nil
local sl                    = nil
local update                = nil
local render                = nil

return function(instance, enable)
    -- / ------------------------------------------------------------------ \ --
    -- | Import modules                                                     | --
    -- \ ------------------------------------------------------------------ / --
    local l                 = love
    local lt                = l.timer
    local lg                = l.graphics
    local Data              = Core.import 'nexus.core.data'
    local Game              = Core.import 'nexus.core.game'
    local Graphics          = Core.import 'nexus.core.graphics'
    local Input             = Core.import 'nexus.core.input'
    local Scene             = Core.import 'nexus.core.scene'
    local Color             = Core.import 'nexus.base.color'
    local Font              = Core.import 'nexus.base.font'
    local GameConsole       = Core.import 'nexus.game.console'

    -- / ------------------------------------------------------------------ \ --
    -- | Declare object                                                     | --
    -- \ ------------------------------------------------------------------ / --
    local Debug             = {
        messages            = nil,
        scenes              = {}
    }

    -- / ------------------------------------------------------------------ \ --
    -- | Local variables                                                    | --
    -- \ ------------------------------------------------------------------ / --
    local m_x_offset        = 8
    local m_y_offset        = 8
    local m_line_height     = 24
    local t_title_color     = Color.new(255, 255, 0, 255)
    local t_default_color   = Color.new(255, 255, 255, 255)

    -- / ------------------------------------------------------------------ \ --
    -- | Member functions                                                   | --
    -- \ ------------------------------------------------------------------ / --
    function Debug.profiler()
    end

    if not enable then
        lg.isSupported = lgis
        lg.getMode = lggm
        lg.setMode = lgsm
        Scene.change = sc
        Scene.goto = sg
        Scene.enter = se
        Scene.leave = sl
        Graphics.update = update
        Graphics.render = render
        return EMPTY_FUNCTION
    end

    extend_love_functions()

    -- / ------------------------------------------------------------------ \ --
    -- | Game hooks in debug mode                                           | --
    -- \ ------------------------------------------------------------------ / --
    lgis                    = lg.isSupported
    lggm                    = lg.getMode
    lgsm                    = lg.setMode
    sc                      = Scene.change
    sg                      = Scene.goto
    se                      = Scene.enter
    sl                      = Scene.leave
    update                  = Graphics.update
    render                  = Graphics.render

    if l._version ~= '0.9.0' then
        function lg.setDefaultFilter(...)
            return lg.setDefaultImageFilter(...)
        end

        function lg.newShader(vertexcode, pixelcode)
            return lg.newPixelEffect(pixelcode)
        end

        function lg.setShader(...)
            return lg.setPixelEffect(...)
        end

        function lg.getShader(...)
            return lg.getPixelEffect(...)
        end

        function lg._shaderCodeToGLSL(...)
            return lg._effectCodeToGLSL(...)
        end

        function lg.isSupported(...)
            local args = {...}
            for index, value in ipairs(args) do
                if value == 'shader' then args[index] = 'pixeleffect' end
            end
            return lgis(unpack(args))
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

    function Scene.change(scene)
        Debug.scenes[#Debug.scenes] = scene
        return sc(scene)
    end

    function Scene.goto(scene)
        if #Debug.scenes > 0 then table.remove(Debug.scenes) end
        table.insert(Debug.scenes, scene)
        return sg(scene)
    end

    function Scene.enter(scene)
        table.insert(Debug.scenes, scene)
        return se(scene)
    end

    function Scene.leave(scene)
        if #Debug.scenes == 0 then return end
        table.remove(Debug.scenes)
        return sl(scene)
    end

    function Graphics.update(...)
        update(...)

        Debug.messages = {}
        for _, scene in ipairs(Debug.scenes) do
            if scene.__debug then
                local messages = scene.__debug(scene);
                table.insert(Debug.messages, 1, {
                    table.remove(messages, 1),
                    #messages,
                    table.concat(messages, '\n')
                })
            end
        end
    end

    function Graphics.render(...)
        local position = 0
        local width, height, flags = lg.getMode()

        render(...)

        if not GameConsole.isConsoleEnabled() then
            local font = Data.getFont('debug')
            local size = font.size

            font.color = t_default_color

            Font.text(font, string.format('FPS: %d', lt.getFPS()), m_x_offset, m_y_offset, width, m_line_height)
            Font.text(font, string.format('Lua Memory Usage: %d KB', collectgarbage('count')), m_x_offset, m_y_offset + m_line_height, width, m_line_height)
            Font.text(font, string.format('Screen: %d x %d (%s, vsync %s, fsaa %d)', width, height, flags.fullscreen and 'fullscreen' or 'windowed', flags.vsync and 'enabled' or 'disabled', flags.fsaa), m_x_offset, m_y_offset + 2 * m_line_height, width, m_line_height)
            Font.text(font, string.format('Date: %s', os.date(Data.getFormat('datetime'))), m_x_offset, m_y_offset + 3 * m_line_height, width, m_line_height)

            font.size = 48
            font.bold = true
            Font.text(font, string.format('NOT FINAL GAME'), 0, 60, width, 2 * m_line_height, Font.ALIGN_CENTER)

            font.size = size
            font.bold = false
            Font.text(font, string.format('CODE NEXUS %s (%s) on %s.', Game.getVersionString(), VERSION.STAGE, l._os), 0, height - 24, width - 8, m_line_height, Font.ALIGN_RIGHT)

            for _, message in ipairs(Debug.messages) do
                local name, lines, messages = unpack(message)
                font.color = t_title_color
                Font.text(font, name, 24, 120 + position * m_line_height, width, m_line_height)

                font.color = t_default_color
                Font.text(font, messages, 32, 120 + (position + 1) * m_line_height, width, m_line_height * lines)

                position = position + lines + 1
            end
        end
    end

    Input.bindKeyEvent('debug.quickstart', Input.TRIGGER, KEYS.F5, function()
        local SceneNewGame = Core.import 'nexus.scene.newgame'
        Scene.goto(SceneNewGame.new())
    end)

    return Debug
end

end

return function(instance, enable)
    extend_love_functions()

    return setmetatable({}, {
        __index             = EMPTY_FUNCTION
    })
end
