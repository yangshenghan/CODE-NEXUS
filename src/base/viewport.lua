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
local Graphics              = Core.import 'nexus.core.graphics'
local Rectangle             = Core.import 'nexus.base.rectangle'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Viewport              = {
    visible                 = true,
    ox                      = 0,
    oy                      = 0,
    z                       = 0
}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Viewport.new(...)
    local instance = setmetatable({}, { __index = Viewport })
    
    if ... == nil then
        instance.rectangle = Rectangle.new(0, 0, Graphics.getScreenWidth(), Graphics.getScreenHeight())
    elseif type(...) == 'table' then
        local args = ...
        instance.rectangle = args.rectangle or Rectangle.new(args.x or 0, args.y or 0, args.width or Graphics.getScreenWidth(), args.height or Graphics.getScreenHeight())
    else
        local x, y, width, height = unpack({...})
        instance.rectangle = Rectangle.new(x, y, width, height)
    end
    return instance
end

function Viewport.flash(instance, color, duration)
end

function Viewport.update(instance, dt)
end

return Viewport
