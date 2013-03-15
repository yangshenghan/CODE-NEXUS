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
nexus.console = {}

local lk = love.keypressed

local focus = nil

local chunk = nil

local prompt1 = '> '

local prompt2 = '| '

local prompt = prompt1

local input = {
    history = {},
    selected = 1,
    lines = {},
    cursor = 1,
    completenext = nil,
    hooks = {},
    complete_add_parens = true,
    complete_base = _G,
    console_command_execute = function() end
}

local function chars(str)
    local t = {}
        for c in str:gmatch(".") do
            t[#t + 1] = c
        end
    return t
end

local function console_purge_history(command)
    for i = #input.history, 1, -1 do
        if input.history[i] == command then
            table.remove(input.history, i)
        end
    end
end

local function console_keypressed_event(key, code)
    if key ~= 'tab' then
        input.completenext = nil
    end

    if input.hooks[key] then
        input.hooks[key]()
    elseif code > 31 and code < 256 then
        table.insert(input.lines, input.cursor, string.char(code))
        input.cursor = input.cursor + 1
    end
end

local function get_current_line()
    return table.concat(input.lines)
end

local function get_relative_position()
    return input.cursor - #input.lines - 1
end

local function initialize_input_stream()
    input.hooks['return'] = function()
        local command = table.concat(input.lines)
        console_purge_history(command)
        input.history[#input.history + 1] = command
        input.selected = #input.history + 1
        input.cursor = 1
        input.lines = {}
        input.console_command_execute(command)
    end
    input.hooks.kpenter = input.hooks['return']

    input.hooks.backspace = function()
        if input.cursor > 1 then
            input.cursor = input.cursor - 1
            table.remove(input.lines, input.cursor)
        else
            input.cursor = 1
        end
    end

    input.hooks.delete = function()
        table.remove(input.lines, input.cursor)
    end

    input.hooks.left = function()
        input.cursor = math.max(1, input.cursor - 1)
    end

    input.hooks.right = function()
        input.cursor = math.min(#input.lines + 1, input.cursor + 1)
    end

    input.hooks.up = function()
        input.selected = math.max(1, input.selected - 1)
        input.lines = chars(input.history[input.selected] or '')
        input.cursor = #input.lines + 1
    end

    input.hooks.down = function()
        input.selected = math.min(#input.history + 1, input.selected + 1)
        input.line = chars(input.history[input.selected] or '')
        input.cursor = #input.lines + 1
    end

    input.hooks.home = function()
        input.cursor = 1
    end

    input.hooks['end'] = function()
        input.cursor = #input.lines + 1
    end

	input.hooks.tab = function()
        if input.completenext then
            return input.completenext()
        end

        local inp = get_current_line()
        local left = 0
        local right = 0

        repeat
            left, right = string.find(inp, '[^%s%[%]%(%)%+%-%*/%%,=]+', right + 1)
        until not right or right >= input.cursor - 1

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

        local search = self.complete_base
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

        input.completenext = coroutine.wrap(function()
            while true do
                for _, c in ipairs(completions) do
                    local advance = #c.key
                    for char in c.key:gmatch(".") do
                        table.insert(input.lines, input.cursor, char)
                    end
                    input.cursor = input.cursor + advance
                    if input.complete_add_parens and c.type == 'function' then
                        table.insert(input.lines, input.cursor, '(')
                        table.insert(input.lines, input.cursor + 1, ')')
                        input.cursor = input.cursor + 1
                    end
                    coroutine.yield()

                    if input.complete_add_parens and c.type == 'function' then
                        table.remove(input.lines, input.cursor)
                        input.cursor = input.cursor - 1
                    end

                    for i = 0, advance do
                        table.remove(input.lines, input.cursor - i)
                    end
                    input.cursor = input.cursor - advance
                end
            end
        end)
        return input.completenext()
    end
end

local output = {
    font = nil,
    width = nil,
    height = nil,
    spacing = nil,
    lines = {},
    char_width = 0,
    char_height = 0,
    line_height = 0,
    lines_per_screen = 0,
    chars_per_line = 0
}

local function output_stream_draw(ox, oy, position)
    assert(ox and oy)
    if not position then return end

    local current_font = love.graphics.getFont() or output.font
    love.graphics.setFont(output.font)
    local lines_to_display = output.lines_per_screen - math.floor((output.height - oy) / output.line_height)
    for i = #output.lines, math.max(1, #output.lines - lines_to_display), -1 do
    love.graphics.print(output.lines[i], ox, oy - (#output.lines - i + 1) * output.line_height)
    end
    love.graphics.setFont(current_font)

    local color = {love.graphics.getColor()}

    love.graphics.setColor(color[1], color[2], color[3], color[4] / 3)

    position = output.lines[#output.lines]:len() + position - 1
    local char_offset = position % output.chars_per_line
    local line_offset = math.floor(position / output.chars_per_line)

    local cur = {}
    cur.w = output.char_width + 1
    cur.h = output.char_height + 1
    cur.x = ox + output.char_width * char_offset
    cur.y = oy - cur.h + output.line_height * line_offset - 1
    love.graphics.rectangle('fill', cur.x, cur.y, cur.w, cur.h)
    love.graphics.setColor(unpack(color))
end

local function output_stream_push(...)
    local str = table.concat{...}
    local added = 0
    for line in str:gmatch('[^\n]+') do
        while string.len(line) > output.chars_per_line do
            output.lines[#output.lines + 1] = line:sub(1, output.chars_per_line)
            line = line:sub(output.chars_per_line+1)
            added = added + 1
        end
        output.lines[#output.lines + 1] = line
        added = added + 1
    end
    return added
end

local function output_stream_pop(n)
    local n = n or 1
    if n < 1 then
        return nil
    end
    return table.remove(output.lines), output_stream_pop(n - 1)
end

local function initialize_output_stream(font, width, height, spacing)
    output.font = font or love.graphics.getFont()
    output.width = width or love.graphics.getWidth()
    output.height = height or love.graphics.getHeight()
    output.spacing = spacing or 4

    output.char_width = output.font.getWidth(output.font, '_')
    output.char_height = output.font:getHeight('|')
    output.line_height = output.char_height + output.spacing

    output.lines_per_screen = math.floor(output.height / output.line_height) - 1
    output.chars_per_line = math.floor(output.width / output.char_width) - 1
end

function initialize_console_object(font, width, height, spacing)
    initialize_input_stream()
    initialize_output_stream(font, width, height, spacing)

    input.console_command_execute = function(command)
        output_stream_push(prompt, command)
        command = command:gsub('^=%s?', 'return '):gsub('^return%s+(.*)(%s*)$', 'print(%1)%2')
        chunk = chunk and table.concat({chunk, command}, ' ') or command
        local ok, out = pcall(function() assert(loadstring(chunk))() end)
        if not ok and out:match('\'<eof>\'') then
            prompt = prompt2
            input.history[#input.history] = nil
        else
            prompt = prompt1
            if out and out:len() > 0 then
                output_stream_push(out)
            end
            input.history[#input.history] = chunk
            chunk = nil
        end
    end
end

local function output_push_message(...)
    local n_args, s = select('#', ...), {...}
    for i = 1, n_args do
        s[i] = (s[i] == nil) and 'nil' or tostring(s[i])
    end
    if n_args == 0 then s = {' '} end
    output_stream_push(table.concat(s, ' '))
end

function nexus.console.draw(ox, oy)
    assert(ox and oy)
    local s = table.concat{prompt, get_current_line(), ' '}
    local n = output_stream_push(s)
    output_stream_draw(4, love.graphics.getHeight() - 4, get_relative_position())
    output_stream_pop(n)
end

function nexus.console.focus()
    if focus then
        focus.unfocus(focus)
    end
    love.keypressed = function(...)
        nexus.console.keypressed(...)
    end
    focus = nexus.console
end

function nexus.console.unfocus(key)
    love.keypressed = lk
    focus = nil
    love.keypressed(key)
end

function nexus.console.keypressed(...)
    console_keypressed_event(...)
end

function nexus.console.showErrorMessage(...)
    if nexus.system.level > 0 then
        output_push_message('[ ERROR ]', ...)
    end
end

function nexus.console.showWarningMessage(...)
    if nexus.system.level > 1 then
        output_push_message('[WARNING]', ...)
    end
end

function nexus.console.showInformationMessage(...)
    if nexus.system.level > 2 then
        output_push_message('[I N F O]', ...)
    end
end

function nexus.console.showLogMessage(...)
    if nexus.system.level > 3 then
        output_push_message('[ L O G ]', ...)
    end
end

function nexus.console.showDebugMessage(...)
    if nexus.system.level > 4 then
        output_push_message('[ DEBUG ]', ...)
    end
end

function nexus.console.initialize()
    local font = nexus.resource.loadFont('inconsolata.otf', 16)

    initialize_console_object(font)
end

function nexus.console.finalize()
end

function nexus.console.update(dt)
end

function nexus.console.render()
    -- if nexus.settings.console then
        -- local color = {love.graphics.getColor()}
        -- love.graphics.setColor(34, 34, 34, 180)
        -- love.graphics.rectangle('fill', 2, 2, love.graphics.getWidth() - 4, love.graphics.getHeight() - 4)
        -- love.graphics.setColor(240, 240, 0, 255)
        -- nexus.console.draw(4, love.graphics.getHeight() - 4)
        -- love.graphics.setColor(unpack(color))
    -- end
end
