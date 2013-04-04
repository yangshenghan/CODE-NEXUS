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
local Nexus                 = nexus
local Core                  = Nexus.core
local Resource              = Core.import 'nexus.core.resource'
local Color                 = Core.import 'nexus.base.color'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Font                  = {
    color                   = nil,
    outline_color           = nil,
    bold                    = false,
    italic                  = false,
    underline               = false,
    delete                  = false,
    outline                 = true,
    shadow                  = true,
    align                   = 0,
    rotate                  = 0,
    zx                      = 1,
    zy                      = 1,
    ox                      = 0,
    oy                      = 0,
    sx                      = 0,
    sy                      = 0,
    size                    = 24,
    ALIGN_LEFT              = 0,
    ALIGN_JUSTIFY           = 1,
    ALIGN_CENTER            = 2,
    ALIGN_RIGHT             = 3
}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Font.new(name, size)
    local instance = setmetatable({}, { __index = Font })
    instance.color = Color.new(255, 255, 255, 255)
    instance.outline_color = Color.new(0, 0, 0, 128)
    instance.name = name
    instance.size = size
    instance.font = Resource.loadFontData(name, size)
    return instance
end

function Font.text(instance, text, ...)
    local x, y, width, height = ...
    local scissor = { lg.getScissor() }

    love.graphics.setScissor(x, y, width, height)
    if instance.align == Font.ALIGN_RIGHT then
        lg.printf(text, x, y, width, 'right', rotate, zx, zy, ox, oy, sx, sy)
    elseif instance.align == Font.ALIGN_CENTER then
        lg.printf(text, x, y, width, 'center', rotate, zx, zy, ox, oy, sx, sy)
    elseif instance.align == Font.ALIGN_JUSTIFY then
        lg.printf(text, x, y, width, 'justify', rotate, zx, zy, ox, oy, sx, sy)
    else
        lg.printf(text, x, y, width, 'left', rotate, zx, zy, ox, oy, sx, sy)
    end
    love.graphics.setScissor(unpack(scissor))
end

return Font
