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
local lk                    = l.keyboard
local Nexus                 = nexus
local Core                  = Nexus.core
local Settings              = Nexus.settings
local Game                  = Core.import 'nexus.core.game'
local Resource              = Core.import 'nexus.core.resource'
local Scene                 = Core.import 'nexus.core.scene'
local GameConsole           = Core.import 'nexus.game.console'
local SceneBase             = Core.import 'nexus.scene.base'
local GameConsoleInput      = GameConsole.getConsoleInput()
local GameConsoleOutput     = GameConsole.getConsoleOutput()

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SceneConsole          = {}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_prompt              = '> '

local m_chunk               = nil

local m_flag                = nil

local m_pressed             = nil

local m_repeated            = nil
    
local t_instance            = nil

local KEYCODES              = {
    [0x08]                  = 'backspace',
    [0x09]                  = 'tab',
    [0x0D]                  = 'return',
    [0x1B]                  = 'escape',
    [0x20]                  = ' ',
    [0x27]                  = '\'',
    [0x2C]                  = ',',
    [0x2D]                  = '-',
    [0x2E]                  = '.',
    [0x2F]                  = '/',
    [0x30]                  = '0',
    [0x31]                  = '1',
    [0x32]                  = '2',
    [0x33]                  = '3',
    [0x34]                  = '4',
    [0x35]                  = '5',
    [0x36]                  = '6',
    [0x37]                  = '7',
    [0x38]                  = '8',
    [0x39]                  = '9',
    [0x3B]                  = ';',
    [0x3D]                  = '=',
    [0x40]                  = 'kp0',
    [0x41]                  = 'kp1',
    [0x42]                  = 'kp2',
    [0x43]                  = 'kp3',
    [0x44]                  = 'kp4',
    [0x45]                  = 'kp5',
    [0x46]                  = 'kp6',
    [0x47]                  = 'kp7',
    [0x48]                  = 'kp8',
    [0x49]                  = 'kp9',
    [0x4A]                  = 'kp+',
    [0x4B]                  = 'kp-',
    [0x4C]                  = 'kp*',
    [0x4D]                  = 'kp/',
    [0x4E]                  = 'kp=',
    [0x4F]                  = 'kpenter',
    [0x50]                  = 'up',
    [0x51]                  = 'right',
    [0x52]                  = 'down',
    [0x53]                  = 'left',
    [0x54]                  = 'home',
    [0x55]                  = 'end',
    [0x56]                  = 'pageup',
    [0x57]                  = 'pagedown',
    [0x5B]                  = '[',
    [0x5C]                  = '\\',
    [0x5D]                  = ']',
    [0x60]                  = '`',
    [0x61]                  = 'a',
    [0x62]                  = 'b',
    [0x63]                  = 'c',
    [0x64]                  = 'd',
    [0x65]                  = 'e',
    [0x66]                  = 'f',
    [0x67]                  = 'g',
    [0x68]                  = 'h',
    [0x69]                  = 'i',
    [0x6A]                  = 'j',
    [0x6B]                  = 'k',
    [0x6C]                  = 'l',
    [0x6D]                  = 'm',
    [0x6E]                  = 'n',
    [0x6F]                  = 'o',
    [0x70]                  = 'p',
    [0x71]                  = 'q',
    [0x72]                  = 'r',
    [0x73]                  = 's',
    [0x74]                  = 't',
    [0x75]                  = 'u',
    [0x76]                  = 'v',
    [0x77]                  = 'w',
    [0x78]                  = 'x',
    [0x79]                  = 'y',
    [0x7A]                  = 'z'
}

local KEYCODESMODIFIER      = {
    [0x27]                  = '"',
    [0x2C]                  = '<',
    [0x2D]                  = '_',
    [0x2E]                  = '>',
    [0x2F]                  = '?',
    [0x30]                  = ')',
    [0x31]                  = '!',
    [0x32]                  = '@',
    [0x33]                  = '#',
    [0x34]                  = '$',
    [0x35]                  = '%',
    [0x36]                  = '^',
    [0x37]                  = '&',
    [0x38]                  = '*',
    [0x39]                  = '(',
    [0x3B]                  = ':',
    [0x3D]                  = '+',
    [0x5B]                  = '{',
    [0x5C]                  = '|',
    [0x5D]                  = '}',
    [0x60]                  = '~',
    [0x61]                  = 'A',
    [0x62]                  = 'B',
    [0x63]                  = 'C',
    [0x64]                  = 'D',
    [0x65]                  = 'E',
    [0x66]                  = 'F',
    [0x67]                  = 'G',
    [0x68]                  = 'H',
    [0x69]                  = 'I',
    [0x6A]                  = 'J',
    [0x6B]                  = 'K',
    [0x6C]                  = 'L',
    [0x6D]                  = 'M',
    [0x6E]                  = 'N',
    [0x6F]                  = 'O',
    [0x70]                  = 'P',
    [0x71]                  = 'Q',
    [0x72]                  = 'R',
    [0x73]                  = 'S',
    [0x74]                  = 'T',
    [0x75]                  = 'U',
    [0x76]                  = 'V',
    [0x77]                  = 'W',
    [0x78]                  = 'X',
    [0x79]                  = 'Y',
    [0x7A]                  = 'Z'
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function executer(command)
    local history = GameConsoleInput.getInputHistory()
    GameConsoleOutput.push(m_prompt, command)
    command = string.gsub(command, '^=%s?', 'return ')
    command = string.gsub(command, '^return%s+(.*)(%s*)$', 'print(%1)%2')
    m_chunk = m_chunk and table.concat({m_chunk, command}, ' ') or command
    local ok, out = pcall(function() assert(loadstring(m_chunk))() end)
    if not ok and string.match(out, '\'<eof>\'') then
        m_prompt = '| '
        history[#history] = nil
    else
        m_prompt = '> '
        if out and string.len(out) > 0 then
            GameConsoleOutput.push(out)
        end
        history[#history] = m_chunk
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
    instance.r = Scene.render
    instance.u = Scene.update 
    instance.print = print
    instance.printf = printf
    instance.reset = reset
    instance.quit = quit
    instance.exit = exit

    Scene.render = function()
        local color = { lg.getColor() }
        if instance.r then instance.u() end

        lg.setColor(34, 34, 34, 180)
        lg.rectangle('fill', 2, 2, lg.getWidth() - 4, lg.getHeight() - 4)
        lg.setColor(240, 240, 0, 255)

        -- assert(ox and oy)
        local s = table.concat{m_prompt, GameConsoleInput.current(), ' '}
        local n = GameConsoleOutput.push(s)
        GameConsoleOutput.render(4, lg.getHeight() - 4, GameConsoleInput.position())
        GameConsoleOutput.pop(n)

        lg.setColor(unpack(color))
    end

    Scene.update = function(dt)
        if not m_flag or not lk.isDown(m_flag) then
            m_flag = nil
            m_pressed = nil
            m_repeated = nil
        end

        m_flag = nil
        for code, key in pairs(KEYCODES) do
            if lk.isDown(key) then
                local char = key
                if KEYCODESMODIFIER[code] and (lk.isDown('lshift', 'rshift') or (lk.isDown('capslock') and code > 0x60 and code <= 0x7A)) then
                    char = KEYCODESMODIFIER[code]
                end
                if char ~= 'tab' then f_autocomplete = nil end
                if char == 'escape' then Scene.leave() end

                if m_pressed then
                    if m_pressed >= 15 then
                        m_pressed = nil
                        m_repeated = 0
                    else
                        m_flag = key
                        m_pressed = m_pressed + 1
                    end
                end

                if m_repeated then
                    if m_repeated >= 3 then
                        m_repeated = 0
                    else
                        m_flag = key
                        m_repeated = m_repeated + 1
                    end
                end

                if not m_pressed and not m_repeated then m_pressed = 0 end
                if not m_flag then
                    m_flag = key
                    GameConsoleInput.push(char)
                end
            end
        end

        if instance.u then instance.u(dt) end
    end

    print = function(...)
        return GameConsole.print(...)
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

    Settings.console = true
end

function SceneConsole.leave(instance)
    exit = instance.exit
    quit = instance.quit
    reset = instance.reset
    printf = instance.printf
    print = instance.print
    Scene.update = instance.u
    Scene.render = instance.r

    instance.exit = nil
    instance.quit = nil
    instance.reset = nil
    instance.printf = nil
    instance.print = nil
    instance.u = nil
    instance.r = nil

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
