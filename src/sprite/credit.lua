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
local table                 = table
local string                = string
local ipairs                = ipairs
local coroutine             = coroutine
local l                     = love
local lg                    = l.graphics
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Data                  = Core.import 'nexus.core.data'
local Graphics              = Core.import 'nexus.core.graphics'
local Font                  = Core.import 'nexus.base.font'
local Rectangle             = Core.import 'nexus.base.rectangle'
local SpriteBase            = Core.import 'nexus.sprite.base'
local REFERENCE_WIDTH       = Constants.REFERENCE_WIDTH
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SpriteCredit          = {
    coroutines              = nil,
    lines                   = nil,
    canvas                  = nil,
    current                 = nil,
    scrolling               = true,
    index                   = 0,
    limit                   = 0,
    wait                    = 0,
    speed                   = 3,
    fadespeed               = 0,
    difference              = 0
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function process_escaped_character(line)
    line = string.gsub(line, '\\t', '    ')
    return line, Font.ALIGN_CENTER
end

local function update_credit_end(instance, dt)
    while instance.wait > 0 do
        if instance.picture then instance.picture[4] = instance.picture[4] - instance.difference end
        instance.wait = instance.wait - 1
        coroutine.yield()
    end

    while instance.opacity > 0 do
        instance.opacity = instance.opacity - instance.fadespeed
        coroutine.yield()
    end

    table.insert(instance.coroutines, 1, nil)
end

local function update_credit_position(instance, dt)
    while instance.y > instance.limit do
        instance.y = instance.y - instance.speed
        coroutine.yield()
    end
    table.insert(instance.coroutines, 1, coroutine.create(update_credit_end))
end

local function update_credit_start(instance, dt)
    while instance.opacity < 1 do
        instance.opacity = instance.opacity + instance.fadespeed
        coroutine.yield()
    end
    table.insert(instance.coroutines, 1, coroutine.create(update_credit_position))
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SpriteCredit.new(contents, limit, viewport)
    local instance = SpriteBase.new(SpriteCredit, viewport)
    local framerate = Graphics.getFramerate()
    instance.lines = {}

    string.gsub(contents, '(.-)\r?\n', function(line)
        table.insert(instance.lines, line)
    end)

    do
        local font = Data.getFont('window')
        local lineheight = Font.getHeight(font)
        local width = REFERENCE_WIDTH
        local height = #instance.lines * lineheight

        instance.y = (REFERENCE_HEIGHT + lineheight) * 0.5
        instance.canvas = lg.newCanvas(width, height)
        instance.rectangle = Rectangle.set(instance.rectangle, 0, 0, width, height)

        if limit then
            instance.limit = limit
        else
            instance.limit = instance.y - height
        end

        lg.setCanvas(instance.canvas)
        for index, line in ipairs(instance.lines) do
            local text, align = process_escaped_character(line)
            Font.text(font, text, 0, (index - 1) * lineheight, width, lineheight, align)
        end
        lg.setCanvas()
    end

    instance.pictures = {}
    instance.coroutines = {
        coroutine.create(update_credit_start)
    }
    instance.opacity = 0
    instance.visible = true
    SpriteCredit.setWaitingFrames(instance, framerate)
    SpriteCredit.setFadespeedFrames(instance, framerate)
    SpriteCredit.setTransitionFrames(instance, framerate)
    return instance
end

function SpriteCredit.update(instance, dt)
    local sprite_update_coroutine = table.first(instance.coroutines)

    SpriteBase.beforeUpdate(instance, dt)
    if instance.scrolling and sprite_update_coroutine then coroutine.resume(sprite_update_coroutine, instance, dt) end
    SpriteBase.afterUpdate(instance, dt)
end

function SpriteCredit.render(instance)
    local picture = instance.picture

    SpriteBase.beforeRender(instance)
    if picture then
        lg.setColor(SpriteBase.getColor(instance.color, picture[4]))
        lg.draw(picture[3], picture[1], picture[2])
    end
    lg.draw(instance.canvas, instance.x, instance.y)
    SpriteBase.afterRender(instance)
end

function SpriteCredit.pause(instance)
    instance.scrolling = false
end

function SpriteCredit.resume(instance)
    instance.scrolling = true
end

function SpriteCredit.setWaitingFrames(instance, frames)
    instance.wait = frames
    instance.difference = 1 / frames
end

function SpriteCredit.setFadespeedFrames(instance, frames)
    instance.fadespeed = 1 / frames
end

return SpriteCredit
