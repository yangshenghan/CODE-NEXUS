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
local nexus                 = nexus

nexus.scene.console         = {}

local Nexus                 = nexus
local Systems               = Nexus.systems
local Settings              = Nexus.settings

local NEXUS_EMPTY_FUNCTION  = NEXUS_EMPTY_FUNCTION

-- / ---------------------------------------------------------------------- \ --
-- | Local used name and modules                                            | --
-- \ ---------------------------------------------------------------------- / --
nexus.console = {}
nexus.console.input = {}
nexus.console.output = {}

local console = nexus.console

-- / ---------------------------------------------------------------------- \ --
-- | The submodule input of the nexus.console                               | --
-- \ ---------------------------------------------------------------------- / --
local m_cursor = 1

local m_selected = 1

local m_commandline = {}

local t_hooks = {}

local t_history = {}

local t_functions = _G

local f_executer = nil

local f_autocomplete = nil

local function chars(s)
    local t = {}
        for c in string.gmatch(s, '.') do
            t[#t + 1] = c
        end
    return t
end

function console.input.purge(command)
    for index = #t_history, 1, -1 do
        if t_history[index] == command then
            table.remove(t_history, index)
        end
    end
end

function console.input.current()
    return table.concat(m_commandline)
end

function console.input.position()
    return m_cursor - #m_commandline - 1
end

function console.input.push(key, code)
    if t_hooks[key] then
        t_hooks[key]()
    elseif code > 31 and code < 256 then
        table.insert(m_commandline, m_cursor, string.char(code))
        m_cursor = m_cursor + 1
    end
end

function console.input.initialize(executer)
    f_executer = executer or NEXUS_EMPTY_FUNCTION

    t_hooks['return'] = function()
        local command = table.concat(m_commandline)
        console.input.purge(command)
        m_commandline = {}
        m_cursor = 1
        m_selected = #t_history + 1
        t_history[#t_history + 1] = command
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
        if f_autocomplete then
            return f_autocomplete()
        end

        local inp = console.input.current()
        local left = 0
        local right = 0

        repeat
            left, right = string.find(inp, '[^%s%[%]%(%)%+%-%*/%%,=]+', right + 1)
        until not right or right >= m_cursor - 1

        if not left or not right then
            return
        end
        inp = string.sub(inp, left, right)

        local tables = {}
        for t in string.gmatch(inp, '[^%.]+') do
            tables[#tables + 1] = t
        end
        local pattern = table.concat{'^', (tables[#tables] or ''):gsub('[%[%]%(%)]', function(s) return '%'..s end), '.*'}

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
            if key:match(pattern) then
                completions[#completions + 1] = {key = key:sub(pattern:len()-2):reverse(), type = type(val)}
            end
        end

        if #completions < 1 then
            return
        end

        f_autocomplete = coroutine.wrap(function()
            while true do
                for _, c in ipairs(completions) do
                    local advance = #c.key
                    for char in c.key:gmatch('.') do
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

-- / ---------------------------------------------------------------------- \ --
-- | The submodule output of the nexus.console                              | --
-- \ ---------------------------------------------------------------------- / --
local m_font = nil

local m_width = nil

local m_height = nil

local m_spacing = nil

local m_character_width = 0

local m_character_height = 0

local m_line_height = 0

local m_lines_per_screen = 0

local m_characters_per_line = 0

local t_lines = {}

function console.output.render(ox, oy, position)
    assert(ox and oy)
    if not position then return end

    local current_font = love.graphics.getFont() or m_font
    love.graphics.setFont(m_font)
    local lines_to_display = m_lines_per_screen - math.floor((m_height - oy) / m_line_height)
    for i = #t_lines, math.max(1, #t_lines - lines_to_display), -1 do
    love.graphics.print(t_lines[i], ox, oy - (#t_lines - i + 1) * m_line_height)
    end
    love.graphics.setFont(current_font)

    local color = {love.graphics.getColor()}

    love.graphics.setColor(color[1], color[2], color[3], color[4] / 3)

    position = t_lines[#t_lines]:len() + position - 1
    local char_offset = position % m_characters_per_line
    local line_offset = math.floor(position / m_characters_per_line)

    local cur = {}
    cur.w = m_character_width + 1
    cur.h = m_character_height + 1
    cur.x = ox + m_character_width * char_offset
    cur.y = oy - cur.h + m_line_height * line_offset - 1
    love.graphics.rectangle('fill', cur.x, cur.y, cur.w, cur.h)
    love.graphics.setColor(unpack(color))
end

function console.output.push(...)
    local str = table.concat{...}
    local added = 0
    for line in str:gmatch('[^\n]+') do
        while string.len(line) > m_characters_per_line do
            t_lines[#t_lines + 1] = line:sub(1, m_characters_per_line)
            line = line:sub(m_characters_per_line+1)
            added = added + 1
        end
        t_lines[#t_lines + 1] = line
        added = added + 1
    end
    return added
end

function console.output.pushc(c, ...)
    if not c then return end
    local line = t_lines[#t_lines]
    if line:len() + 1 < m_characters_per_line then
        line = line .. c
    else
        line = c
    end

    t_lines[#t_lines] = line
    return console.output.pushc(...)
end

function console.output.pop(n)
    local n = n or 1
    if n < 1 then
        return nil
    end
    return table.remove(t_lines), console.output.pop(n - 1)
end

function console.output.reset(font, width, height, spacing)
    m_font = font or love.graphics.getFont()
    m_width = width or love.graphics.getWidth()
    m_height = height or love.graphics.getHeight()
    m_spacing = spacing or 4

    m_character_width = m_font.getWidth(m_font, '_')
    m_character_height = m_font:getHeight('|')
    m_line_height = m_character_height + m_spacing

    m_lines_per_screen = math.floor(m_height / m_line_height) - 1
    m_characters_per_line = math.floor(m_width / m_character_width) - 1
end

function console.output.initialize(font, width, height, spacing)
    console.output.reset(font, width, height, spacing)
end

-- / ---------------------------------------------------------------------- \ --
-- | The main module of the nexus.console                                   | --
-- \ ---------------------------------------------------------------------- / --
function console.initialize(executer, font, width, height, spacing)
    console.input.initialize(executer)
    console.output.initialize(font, width, height, spacing)

    console.print([[
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
    console.print()
end

function nexus.console.toggleConsole()
    if Settings.console then
        nexus.core.scene.leave()
    else
        nexus.core.scene.enter(nexus.scene.console.new())
    end
end

function console.print(...)
    local argc, args = select('#', ...), {...}
    for i = 1, argc do
        args[i] = (args[i] == nil) and 'nil' or tostring(args[i])
    end
    if argc == 0 then args = {' '} end
    console.output.push(table.concat(args, ' '))
end

if Systems.debug then
    function console.showErrorMessage(...)
        if Settings.level > 0 then
            console.print('[ ERROR ]', ...)
        end
    end

    function console.showWarningMessage(...)
        if Settings.level > 1 then
            console.print('[WARNING]', ...)
        end
    end

    function console.showInformationMessage(...)
        if Settings.level > 2 then
            console.print('[I N F O]', ...)
        end
    end

    function console.showLogMessage(...)
        if Settings.level > 3 then
            console.print('[ L O G ]', ...)
        end
    end

    function console.showDebugMessage(...)
        if Settings.level > 4 then
            console.print('[ DEBUG ]', ...)
        end
    end
else
    function console.showErrorMessage(...) end
    function console.showWarningMessage(...) end
    function console.showInformationMessage(...) end
    function console.showLogMessage(...) end
    function console.showDebugMessage(...) end
end

-- / ---------------------------------------------------------------------- \ --
-- | The scene of console                                                   | --
-- \ ---------------------------------------------------------------------- / --
local m_prompt = '> '

local m_chunk = nil

local t_instance = nil

local function executer(command)
    console.output.push(m_prompt, command)
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
            console.output.push(out)
        end
        t_history[#t_history] = m_chunk
        m_chunk = nil
    end
end

local function enter(instance)
    instance.ld = love.draw
    instance.lk = love.keypressed
    instance.print = print
    instance.printf = printf
    instance.reset = reset
    instance.quit = quit
    instance.exit = exit

    love.draw = function()
        if instance.ld then instance.ld() end

        local color = {love.graphics.getColor()}
        love.graphics.setColor(34, 34, 34, 180)
        love.graphics.rectangle('fill', 2, 2, love.graphics.getWidth() - 4, love.graphics.getHeight() - 4)
        love.graphics.setColor(240, 240, 0, 255)

        -- assert(ox and oy)
        local s = table.concat{m_prompt, console.input.current(), ' '}
        local n = console.output.push(s)
        console.output.render(4, love.graphics.getHeight() - 4, console.input.position())
        console.output.pop(n)

        love.graphics.setColor(unpack(color))
    end

    love.keypressed = function(key, code)
        if key ~= 'tab' then
            f_autocomplete = nil
        end

        if key == 'escape' then
            nexus.core.scene.leave()
        end

        console.input.push(key, code)

        if instance.lk then instance.lk(key, code) end
    end

    print = function(...)
        return console.print(...)
    end

    printf = function(format, ...)
        return print(string.format(format, ...))
    end

    reset = function()
        nexus.core.game.reload()
    end

    quit = function()
        nexus.core.scene.leave()
    end

    exit = function()
        love.event.quit()
    end

    love.keyboard.setKeyRepeat(0.15, 0.025)

    Settings.console = true
end

local function leave(instance)
    exit = instance.exit
    quit = instance.quit
    reset = instance.reset
    printf = instance.printf
    print = instance.print
    love.keypressed = instance.lk
    love.draw = instance.ld

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

function nexus.scene.console.new()
    if not t_instance then
        local font = nexus.core.resource.loadFontData('inconsolata.otf', 16)
        console.initialize(executer, font)

        t_instance = nexus.base.scene.new({
            enter   = enter,
            leave   = leave
        })
    end
    return t_instance
end

if Systems.debug then
    nexus.scene.console.new()
end

