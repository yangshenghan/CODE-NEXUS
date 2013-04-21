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
local Configures            = Nexus.configures
local GraphicsConfigures    = Configures.graphics
local Resource              = Core.import 'nexus.core.resource'
local SpriteBase            = Core.import 'nexus.sprite.base'

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
    instance.visible = true
    return instance
end

function SpritePicture.update(instance, dt)
    SpriteBase.beforeUpdate(instance, dt)
    instance.ox = GraphicsConfigures.width * 0.5
    instance.oy = GraphicsConfigures.height * 0.5
    SpriteBase.afterUpdate(instance, dt)
end

function SpritePicture.render(instance)
    SpriteBase.beforeRender(instance)
    lg.draw(instance.image, instance.x, instance.y)
    SpriteBase.afterRender(instance)
end

return SpritePicture
