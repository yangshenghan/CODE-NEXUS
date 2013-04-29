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
local math                  = math
local table                 = table
local coroutine             = coroutine
local l                     = love
local lg                    = l.graphics
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Data                  = Core.import 'nexus.core.data'
local Game                  = Core.import 'nexus.core.game'
local Input                 = Core.import 'nexus.core.input'
local Font                  = Core.import 'nexus.base.font'
local GameMessage           = Core.import 'nexus.game.message'
local WindowBase            = Core.import 'nexus.window.base'
local KEYS                  = Constants.KEYS
local REFERENCE_WIDTH       = Constants.REFERENCE_WIDTH
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local WindowMessage         = {
    texts                   = nil,
    coroutine               = nil
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function update_message_placement(instance)
    instance.y = Game.message.position * (REFERENCE_HEIGHT - instance.height) * 0.5
end

local function new_line_x(instance)
    if Game.message.face ~= nil then
        if Game.message.faceposition == GameMessage.FACE_POSITION_LEFT then
            return 160
        else
            return REFERENCE_WIDTH - 160
        end
    end
    return 0
end

local function pause_input(instance)
    while not Input.isKeyTrigger(KEYS.CONFIRM) do coroutine.yield() end
end

local function need_new_page(instance, texts, pos)
    return pos[2] + pos[4] > 4 * WindowBase.calculateLineheight(instance, texts) and string.len(texts) > 0
end

local function new_page(instance, texts, pos)
    pos[1] = new_line_x(instance)
    pos[2] = 0
    pos[3] = new_line_x(instance)
    pos[4] = WindowBase.calculateLineheight(instance, texts)
    instance.texts = {}
end

local function process_new_line(instance, texts, pos)
    pos[1] = pos[3]
    pos[2] = pos[2] + pos[4]
    pos[4] = WindowBase.calculateLineheight(instance, texts)
    if need_new_page(instance, texts, pos) then
        pause_input(instance)
        new_page(instance, texts, pos)
    end
end

local function process_new_page(instance, texts, pos)
    pause_input(instance)
    new_page(instance, texts, pos)
end

local function process_normal_character(instance, c, pos)
    local width = instance.font.getWidth(instance.font, c)
    table.insert(instance.texts, {c, pos[1], pos[2]})
    pos[1] = pos[1] + width
    coroutine.yield()
end

local function process_character(instance, c, texts, pos)
    if c == '\n' then
        process_new_line(instance, texts, pos)
    elseif c == '\f' then
        process_new_page(instance, texts, pos)
    else
        process_normal_character(instance, c, pos)
    end
end

local function process_all_texts(instance)
    local pos = {0, 0, 0, 0} -- x, y, next x, line height
    local index = 0
    local texts = GameMessage.getAllTexts(Game.message)
    local length = string.len(texts)
    -- open_and_wait(instance)
    new_page(instance, texts, pos)
    while index < length do
        index = index + 1
        process_character(instance, string.sub(texts, index, index), string.sub(texts, index + 1, length), pos)
    end
end

local function f_message_coroutine(instance)
    instance.visible = true
    update_message_placement(instance)
    while GameMessage.isBusy(Game.message) do 
        process_all_texts(instance)
        pause_input(instance)
        GameMessage.clear(Game.message)
        coroutine.yield()
    end
    -- close_and_wait(instance)
    instance.visible = false
    instance.coroutine = nil
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function WindowMessage.new()
    local padding = 12
    local lineheight = 32
    local instance = WindowBase.new(WindowMessage, 16, 0, REFERENCE_WIDTH, 4 * lineheight + 2 * padding, Data.getFont('message'))
    instance.texts = {}
    return instance
end

function WindowMessage.update(instance, dt)
    if instance.coroutine then
        coroutine.resume(instance.coroutine, instance)
    elseif GameMessage.isBusy(Game.message) then
        instance.coroutine = coroutine.create(f_message_coroutine)
        coroutine.resume(instance.coroutine, instance)
    else
        instance.visible = false
    end
end

function WindowMessage.render(instance)
    for _, text in ipairs(instance.texts) do
        local c, x, y = unpack(text)
        Font.text(instance.font, c, instance.x + x, instance.y + y, instance.width - instance.x, Font.getLineHeight(instance.font))
    end
end

return WindowMessage
