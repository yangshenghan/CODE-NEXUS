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
local math                  = math
local table                 = table
local pcall                 = pcall
local pairs                 = pairs
local ipairs                = ipairs
local unpack                = unpack
local string                = string
local tostring              = tostring
local coroutine             = coroutine
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Game                  = Core.import 'nexus.core.game'
local Resource              = Core.import 'nexus.core.resource'
local Scene                 = Core.import 'nexus.core.scene'
local GameConsole           = Core.import 'nexus.game.console'
local SceneBase             = Core.import 'nexus.scene.base'
local NEXUS_EMPTY_FUNCTION  = Constants.EMPTY_FUNCTION

local NEXUS_DEBUG_MODE      = Constants.DEBUG_MODE

-- / ---------------------------------------------------------------------- \ --
-- | [ The submodule GameConsoleInput of the GameConsole                  ] | --
-- \ ---------------------------------------------------------------------- / --

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local GameConsoleInput      = {}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_cursor              = 1

local m_selected            = 1

local m_commandline         = {}

local t_hooks               = {}

local t_history             = {}

local t_functions           = _G

local f_executer            = nil

local f_autocomplete        = nil

local function chars(s)
    local t = {}
    for c in string.gmatch(s, '.') do
        table.insert(t, c)
    end
    return t
end

local function current()
    return table.concat(m_commandline)
end

function position()
    return m_cursor - #m_commandline - 1
end

function GameConsoleInput.initialize(executer)
    f_executer = executer or NEXUS_EMPTY_FUNCTION

    t_hooks['return'] = function()
        local command = table.concat(m_commandline)
        GameConsoleInput.purge(command)
        m_commandline = {}
        m_cursor = 1
        m_selected = #t_history + 1
        table.insert(t_history, command)
        f_executer(command)
    end
    t_hooks['kpenter'] = t_hooks['return']

    t_hooks['backspace'] = function()
        if m_cursor > 1 then
            m_cursor = m_cursor - 1
            table.remove(m_commandline, m_cursor)
        else
            m_cursor = 1
        end
    end

    t_hooks['delete'] = function()
        table.remove(m_commandline, m_cursor)
    end

    t_hooks['left'] = function()
        m_cursor = math.max(1, m_cursor - 1)
    end

    t_hooks['right'] = function()
        m_cursor = math.min(#m_commandline + 1, m_cursor + 1)
    end

    t_hooks['up'] = function()
        m_selected = math.max(1, m_selected - 1)
        m_commandline = chars(t_history[m_selected] or '')
        m_cursor = #m_commandline + 1
    end

    t_hooks['down'] = function()
        m_selected = math.min(#t_history + 1, m_selected + 1)
        m_commandline = chars(t_history[m_selected] or '')
        m_cursor = #m_commandline + 1
    end

    t_hooks['home'] = function()
        m_cursor = 1
    end

    t_hooks['end'] = function()
        m_cursor = #m_commandline + 1
    end

    t_hooks['tab'] = function()
        if f_autocomplete then return f_autocomplete() end

        local left = 0
        local right = 0
        local current = current()

        repeat
            left, right = string.find(current, '[^%s%[%]%(%)%+%-%*/%%,=]+', right + 1)
        until not right or right >= m_cursor - 1

        if not left or not right then
            return
        end
        current = string.sub(current, left, right)

        local tables = {}
        for t in string.gmatch(current, '[^%.]+') do
            tables[#tables + 1] = t
        end
        local pattern = table.concat{'^', string.gsub(tables[#tables] or '', '[%[%]%(%)]', function(s) return '%' .. s end), '.*'}

        tables[#tables] = nil

        local search = t_functions
        for _, key in ipairs(tables) do
            if not search[key] then
                return
            end
            search = search[key]
        end

        local completions = {}
        for key, val in pairs(search or {}) do
            if string.match(key, pattern) then
                completions[#completions + 1] = {key = string.reverse(string.sub(key, string.len(pattern) - 2)), type = type(val)}
            end
        end

        if #completions < 1 then
            return
        end

        f_autocomplete = coroutine.wrap(function()
            while true do
                for _, c in ipairs(completions) do
                    local advance = #c.key
                    for char in string.gmatch(c.key, '.') do
                        table.insert(m_commandline, m_cursor, char)
                    end
                    m_cursor = m_cursor + advance
                    if c.type == 'function' then
                        table.insert(m_commandline, m_cursor, '(')
                        table.insert(m_commandline, m_cursor + 1, ')')
                        m_cursor = m_cursor + 1
                    end
                    coroutine.yield()

                    if c.type == 'function' then
                        table.remove(m_commandline, m_cursor)
                        m_cursor = m_cursor - 1
                    end

                    for i = 0, advance do
                        table.remove(m_commandline, m_cursor - i)
                    end
                    m_cursor = m_cursor - advance
                end
            end
        end)
        return f_autocomplete()
    end
end

function GameConsoleInput.purge(command)
    for index = #t_history, 1, -1 do
        if t_history[index] == command then
            table.remove(t_history, index)
        end
    end
end

function GameConsoleInput.push(key)
    if key ~= 'tab' then f_autocomplete = nil end

    if t_hooks[key] then
        t_hooks[key]()
    else
        table.insert(m_commandline, m_cursor, key)
        m_cursor = m_cursor + 1
    end
end

function GameConsoleInput.getInputHistory()
    return t_history
end

-- / ---------------------------------------------------------------------- \ --
-- | [ The submodule GameConsoleOutput of the GameConsole                 ] | --
-- \ ---------------------------------------------------------------------- / --

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local GameConsoleOutput     = {}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_font                = nil

local m_width               = nil

local m_height              = nil

local m_spacing             = nil

local m_character_width     = 0

local m_character_height    = 0

local m_line_height         = 0

local m_lines_per_screen    = 0

local m_characters_per_line = 0

local t_lines               = {}

function GameConsoleOutput.initialize(font, width, height, spacing)
    GameConsoleOutput.reset(font, width, height, spacing)
end

function GameConsoleOutput.render(ox, oy, position)
    assert(ox and oy)
    if not position then return end

    local current_font = lg.getFont() or m_font
    lg.setFont(m_font)
    local lines_to_display = m_lines_per_screen - math.floor((m_height - oy) / m_line_height)
    for i = #t_lines, math.max(1, #t_lines - lines_to_display), -1 do
    lg.print(t_lines[i], ox, oy - (#t_lines - i + 1) * m_line_height)
    end
    lg.setFont(current_font)

    local color = {lg.getColor()}

    lg.setColor(color[1], color[2], color[3], color[4] / 3)

    position = string.len(t_lines[#t_lines]) + position - 1
    local char_offset = position % m_characters_per_line
    local line_offset = math.floor(position / m_characters_per_line)

    local cur = {}
    cur.w = m_character_width + 1
    cur.h = m_character_height + 1
    cur.x = ox + m_character_width * char_offset
    cur.y = oy - cur.h + m_line_height * line_offset - 1
    lg.rectangle('fill', cur.x, cur.y, cur.w, cur.h)
    lg.setColor(unpack(color))
end

function GameConsoleOutput.push(...)
    local str = table.concat{...}
    local added = 0
    for line in string.gmatch(str, '[^\n]+') do
        while string.len(line) > m_characters_per_line do
            t_lines[#t_lines + 1] = string.sub(line, 1, m_characters_per_line)
            line = string.sub(line, m_characters_per_line+1)
            added = added + 1
        end
        t_lines[#t_lines + 1] = line
        added = added + 1
    end
    return added
end

function GameConsoleOutput.pushc(c, ...)
    if not c then return end
    local line = t_lines[#t_lines]
    if string.len(line) + 1 < m_characters_per_line then
        line = line .. c
    else
        line = c
    end

    t_lines[#t_lines] = line
    return GameConsoleOutput.pushc(...)
end

function GameConsoleOutput.pop(n)
    local n = n or 1
    if n < 1 then
        return nil
    end
    return table.remove(t_lines), GameConsoleOutput.pop(n - 1)
end

function GameConsoleOutput.reset(font, width, height, spacing)
    m_font = font or lg.getFont()
    m_width = width or lg.getWidth()
    m_height = height or lg.getHeight()
    m_spacing = spacing or 4

    m_character_width = m_font.getWidth(m_font, '_')
    m_character_height = m_font.getHeight(m_font, '|')
    m_line_height = m_character_height + m_spacing

    m_lines_per_screen = math.floor(m_height / m_line_height) - 1
    m_characters_per_line = math.floor(m_width / m_character_width) - 1
end

-- / ---------------------------------------------------------------------- \ --
-- | [ The main module GameConsole                                        ] | --
-- \ ---------------------------------------------------------------------- / --

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local GameConsole           = {}

GameConsole.reset = NEXUS_EMPTY_FUNCTION
GameConsole.print = NEXUS_EMPTY_FUNCTION
GameConsole.toggle = NEXUS_EMPTY_FUNCTION
GameConsole.setFilterLevel = NEXUS_EMPTY_FUNCTION
GameConsole.registerConsoleCommand = NEXUS_EMPTY_FUNCTION
GameConsole.unregisterConsoleCommand = NEXUS_EMPTY_FUNCTION
GameConsole.clearRegisteredCommands = NEXUS_EMPTY_FUNCTION
GameConsole.showErrorMessage = NEXUS_EMPTY_FUNCTION
GameConsole.showWarningMessage = NEXUS_EMPTY_FUNCTION
GameConsole.showInformationMessage = NEXUS_EMPTY_FUNCTION
GameConsole.showLogMessage = NEXUS_EMPTY_FUNCTION
GameConsole.showDebugMessage = NEXUS_EMPTY_FUNCTION

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_level               = 5
local m_chunk               = nil
local m_prompt              = '> '

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function GameConsole.initialize(font, width, height, spacing)
    GameConsole.reset(font, width, height, spacing)
end

-- / ---------------------------------------------------------------------- \ --
-- | [ The scene of the console                                           ] | --
-- \ ---------------------------------------------------------------------- / --

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SceneConsole          = {}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_flag                = nil

local m_pressed             = nil

local m_repeated            = nil

local m_console             = false

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
    [0x7A]                  = 'z',
    [0x7F]                  = 'delete'
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
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SceneConsole.new()
    if not t_instance then
        local font = Resource.loadFontData('inconsolata.otf', 16)
        GameConsole.initialize(font)
        t_instance = SceneBase.new(SceneConsole)
    end
    return t_instance
end

function SceneConsole.update(instance, dt)
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
end

function SceneConsole.render(instance)
    local color = { lg.getColor() }
    lg.setColor(34, 34, 34, 180)
    lg.rectangle('fill', 2, 2, lg.getWidth() - 4, lg.getHeight() - 4)
    lg.setColor(240, 240, 0, 255)

    local s = table.concat{m_prompt, current(), ' '}
    local n = GameConsoleOutput.push(s)
    GameConsoleOutput.render(4, lg.getHeight() - 4, position())
    GameConsoleOutput.pop(n)

    lg.setColor(unpack(color))
end

function SceneConsole.enter(instance)
    instance.print = print
    instance.printf = printf
    instance.reset = reset
    instance.quit = quit
    instance.exit = exit

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

    m_console = true
end

function SceneConsole.leave(instance)
    exit = instance.exit
    quit = instance.quit
    reset = instance.reset
    printf = instance.printf
    print = instance.print

    instance.exit = nil
    instance.quit = nil
    instance.reset = nil
    instance.printf = nil
    instance.print = nil

    m_console = false
end

-- / ---------------------------------------------------------------------- \ --
-- | [ Public functions of the console                                    ] | --
-- \ ---------------------------------------------------------------------- / --
if NEXUS_DEBUG_MODE then
    function GameConsole.reset(font, width, height, spacing)
        GameConsoleInput.initialize(function(command)
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
                if out and string.len(out) > 0 then GameConsoleOutput.push(out) end
                t_history[#t_history] = m_chunk
                m_chunk = nil
            end
        end)
        GameConsoleOutput.initialize(font, width, height, spacing)

        GameConsole.print([[
/ ******************************************************************************** \
|                                  [ CODE NEXUS ]                                  |
|                           == Console for Code Nexus ==                           |
|                                                                      Version 0.3 |
| -------------------------------------------------------------------------------- |
| Use <F9> to toggle the console window. Call quit() or exit() to exit the game.   |
| Try hitting <Tab> to complete your current input.                                |
| A leading '=' prints the calling result.                                         |
| -------------------------------------------------------------------------------- |
|                           !!!   N  O  T  I  C  E   !!!                           |
| Use console to control code nexus might cause the game behaves abnormal. Please  |
| understand clearly what you are doing now. You can type 'help' to see the notes. |
\ ******************************************************************************** /
]])
        GameConsole.print()
    end

    function GameConsole.print(...)
        local argc, args = select('#', ...), {...}
        for i = 1, argc do
            args[i] = (args[i] == nil) and 'nil' or tostring(args[i])
        end
        if argc == 0 then args = {' '} end
        GameConsoleOutput.push(table.concat(args, ' '))
    end

    function GameConsole.toggle()
        if m_console then
            Scene.leave()
        else
            Scene.enter(SceneConsole.new())
        end
    end

    function GameConsole.setFilterLevel(level)
        if level < 0 then level = 0 end
        if level > 5 then level = 5 end
        m_level = level
    end

    function GameConsole.registerConsoleCommand(command, callback)
    end

    function GameConsole.unregisterConsoleCommand(command)
    end

    function GameConsole.clearRegisteredCommands()
    end

    function GameConsole.showErrorMessage(...)
        if m_level > 0 then
            GameConsole.print('[ ERROR ]', ...)
        end
    end

    function GameConsole.showWarningMessage(...)
        if m_level > 1 then
            GameConsole.print('[WARNING]', ...)
        end
    end

    function GameConsole.showInformationMessage(...)
        if m_level > 2 then
            GameConsole.print('[I N F O]', ...)
        end
    end

    function GameConsole.showLogMessage(...)
        if m_level > 3 then
            GameConsole.print('[ L O G ]', ...)
        end
    end

    function GameConsole.showDebugMessage(...)
        if m_level > 4 then
            GameConsole.print('[ DEBUG ]', ...)
        end
    end
end

return GameConsole
