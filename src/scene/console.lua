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
local Nexus                 = nexus
local Core                  = Nexus.core
local Settings              = Nexus.settings
local Game                  = Core.import 'nexus.core.game'
local Resource              = Core.import 'nexus.core.resource'
local Scene                 = Core.import 'nexus.core.scene'
local GameConsole           = Core.import 'nexus.game.console'
local SceneBase             = Core.import 'nexus.scene.base'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SceneConsole          = {}

local GameConsoleInput      = GameConsole.getConsoleInput()
local GameConsoleOutput     = GameConsole.getConsoleOutput()

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_prompt = '> '

local m_chunk = nil

local t_instance = nil

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function executer(command)
    GameConsoleOutput.push(m_prompt, command)
    command = string.gsub(command, '^=%s?', 'return ')
    command = string.gsub(command, '^return%s+(.*)(%s*)$', 'print(%1)%2')
    m_chunk = m_chunk and table.concat({m_chunk, command}, ' ') or command
    local ok, out = pcall(function() assert(loadstring(m_chunk))() end)
    if not ok and string.match(out, '\'<eof>\'') then
        m_prompt = '| '
        t_history[#t_history] = nil
    else
        m_prompt = '> '
        if out and string.len(out) > 0 then
            GameConsoleOutput.push(out)
        end
        t_history[#t_history] = m_chunk
        m_chunk = nil
    end
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SceneConsole.new()
    if not t_instance then
        local font = Resource.loadFontData('inconsolata.otf', 16)
        GameConsole.initialize(executer, font)

        t_instance = SceneBase.new(SceneConsole)
    end
    return t_instance
end

function SceneConsole.enter(instance)
    instance.ld = Scene.render
    instance.lk = love.keypressed
    instance.print = print
    instance.printf = printf
    instance.reset = reset
    instance.quit = quit
    instance.exit = exit

    Scene.render = function()
        if instance.ld then instance.ld() end

        local color = {love.graphics.getColor()}
        love.graphics.setColor(34, 34, 34, 180)
        love.graphics.rectangle('fill', 2, 2, love.graphics.getWidth() - 4, love.graphics.getHeight() - 4)
        love.graphics.setColor(240, 240, 0, 255)

        -- assert(ox and oy)
        local s = table.concat{m_prompt, GameConsoleInput.current(), ' '}
        local n = GameConsoleOutput.push(s)
        GameConsoleOutput.render(4, love.graphics.getHeight() - 4, GameConsoleInput.position())
        GameConsoleOutput.pop(n)

        love.graphics.setColor(unpack(color))
    end

    love.keypressed = function(key, code)
        if key ~= 'tab' then
            f_autocomplete = nil
        end

        if key == 'escape' then
            Scene.leave()
        end

        GameConsoleInput.push(key, code)

        if instance.lk then instance.lk(key, code) end
    end

    print = function(...)
        return Console.print(...)
    end

    printf = function(format, ...)
        return print(string.format(format, ...))
    end

    reset = function()
        Game.reload()
    end

    quit = function()
        Scene.leave()
    end

    exit = function()
        Game.quit()
    end

    love.keyboard.setKeyRepeat(0.15, 0.025)

    Settings.console = true
end

function SceneConsole.leave(instance)
    exit = instance.exit
    quit = instance.quit
    reset = instance.reset
    printf = instance.printf
    print = instance.print
    love.keypressed = instance.lk
    Scene.render = instance.ld

    instance.exit = nil
    instance.quit = nil
    instance.reset = nil
    instance.printf = nil
    instance.print = nil
    instance.lk = nil
    instance.ld = nil

    love.keyboard.setKeyRepeat(0, 0)

    Settings.console = false
end

function SceneConsole.toggleConsole()
    if Settings.console then
        Scene.leave()
    else
        Scene.enter(SceneConsole.new())
    end
end

return SceneConsole
