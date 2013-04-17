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
local l                     = love
local lg                    = l.graphics
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Data                  = Core.import 'nexus.core.data'
local Grapchis              = Core.import 'nexus.core.graphics'
local Color                 = Core.import 'nexus.base.color'
local Font                  = Core.import 'nexus.base.font'
local Rectangle             = Core.import 'nexus.base.rectangle'
local SpriteBase            = Core.import 'nexus.sprite.base'
local REFERENCE_WIDTH       = Constants.REFERENCE_WIDTH
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SpriteCredit          = {
    lines                   = nil,
    canvas                  = nil,
    pictures                = nil,
    current                 = nil,
    index                   = 0,
    limit                   = 0,
    wait                    = 0,
    diff                    = 0
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function process_escaped_character(line)
    line = string.gsub(line, '\\t', '    ')
    return line, Font.ALIGN_CENTER
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SpriteCredit.new(contents, limit)
    local instance = SpriteBase.new(SpriteCredit)
    instance.lines = {}

    string.gsub(contents, '(.-)\r?\n', function(line)
        table.insert(instance.lines, line)
    end)

    do
        local font = Data.getFont('window')
        local lineheight = Font.getHeight(font)
        local width = REFERENCE_WIDTH
        local height = #instance.lines * lineheight

        instance.canvas = lg.newCanvas(width, height)
        instance.rectangle = Rectangle.set(instance.rectangle, 0, 0, width, height)

        if limit then
            instance.limit = limit
        else
            instance.limit = (REFERENCE_HEIGHT + lineheight) * 0.5 - height
        end

        lg.setCanvas(instance.canvas)
        for index, line in ipairs(instance.lines) do
            local text, align = process_escaped_character(line)
            Font.text(font, text, 0, (index - 1) * lineheight, width, lineheight, align)
        end
        lg.setCanvas()
    end

    instance.y = REFERENCE_HEIGHT
    instance.pictures = {}
    instance.visible = true
    return instance
end

function SpriteCredit.update(instance, dt)
    local picture = instance.pictures[instance.index + 1]

    SpriteBase.update(instance, dt)

    if instance.y > instance.limit then
        instance.y = instance.y - 3
    else
        instance.wait = instance.wait - 1
        if instance.picture then instance.picture[4] = instance.picture[4] - instance.diff end
        if instance.wait <= 0 then
            for index = 1, 60 do
                instance.opacity = instance.opacity - 1 / 60
                lg.clear()
                Grapchis.render()
                lg.present()
            end
            instance.update = function() end
            SpriteCredit.dispose(instance)
        end
    end

    if picture and picture[3] ~= instance.picture[3] then
        if picture[4] ~= 1 then
            picture[4] = picture[4] + 0.05
            if instance.picture then instance.picture[4] = instance.picture[4] - 0.05 end
        else
            instance.picture = picture
        end
    end
end

function SpriteCredit.render(instance)
    local picture = instance.picture
    if picture then
        lg.setColor(SpriteBase.getColor(instance.color, picture[4]))
        lg.draw(picture[3], picture[1], picture[2])
    end
    lg.setColor(SpriteBase.getColor(instance.color, instance.opacity))
    lg.draw(instance.canvas, instance.x, instance.y)
end

function SpriteCredit.setWaitingFrames(instance, frames)
    instance.wait = frames
    instance.diff = 1 / frames
end

function SpriteCredit.addPicture(instance, x, y, picture)
    table.insert(instance.pictures, {x, y, picture, 0})
end

function SpriteCredit.showNextPicture(instance)
    instance.index = (instance.index + 1) % #instance.pictures
end

return SpriteCredit
