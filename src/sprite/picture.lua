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
local Constants             = Nexus.constants
local Configures            = Nexus.configures
local GraphicsConfigures    = Configures.graphics
local Game                  = Core.import 'nexus.core.game'
local Resource              = Core.import 'nexus.core.resource'
local Color                 = Core.import 'nexus.base.color'
local SpriteBase            = Core.import 'nexus.sprite.base'
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT
local LOGICAL_GRID_SIZE     = Constants.LOGICAL_GRID_SIZE

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SpritePicture         = {}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SpritePicture.new(viewport, name)
    local instance = SpriteBase.new(SpritePicture, viewport)
    instance.image = Resource.loadPictureImage(name)
    instance.rectangle.width = instance.image.getWidth(instance.image)
    instance.rectangle.height = instance.image.getHeight(instance.image)
    instance.ox = instance.rectangle.width * 0.5
    instance.oy = instance.rectangle.height * 0.5
    instance.visible = true
    return instance
end

function SpritePicture.render(instance)
    lg.setColor(SpriteBase.getColor(instance.color, instance.opacity))
    lg.draw(instance.image, instance.x + GraphicsConfigures.width * 0.5, instance.y + GraphicsConfigures.height * 0.5, instance.angle, instance.mx and -instance.zx or instance.zx, instance.my and -instance.zy or instance.zy, instance.ox, instance.oy, instance.sx, instance.sy)
end

return SpritePicture
