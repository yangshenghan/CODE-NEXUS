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
local Game                  = Core.import 'nexus.core.game'
local Resource              = Core.import 'nexus.core.resource'
local Rectangle             = Core.import 'nexus.base.rectangle'
local SpriteBase            = Core.import 'nexus.sprite.base'
local REFERENCE_HEIGHT      = Constants.REFERENCE_HEIGHT
local LOGICAL_GRID_SIZE     = Constants.LOGICAL_GRID_SIZE

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SpriteCharacter       = {
    name                    = nil,
    index                   = nil,
    character               = nil
}

local CLIPS_PER_ROW         = 16

local CLIPS_PER_COLUMN      = 16

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function is_sprite_changed(instance)
    return instance.name ~= instance.character.name or instance.index ~= instance.character.index
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SpriteCharacter.new(viewport, character)
    local instance = SpriteBase.new(SpriteCharacter, viewport)
    instance.character = character
    return instance
end

function SpriteCharacter.update(instance, dt)
    SpriteBase.beforeUpdate(instance, dt)

    if instance.character.name and is_sprite_changed(instance) then
        instance.name = instance.character.name
        instance.index = instance.character.index

        instance.image = Resource.loadCharacterImage(instance.name)
    end

    if instance.image then
        local width = instance.image.getWidth(instance.image)
        local height = instance.image.getHeight(instance.image)

        instance.rectangle = Rectangle.set(instance.rectangle, (instance.index + instance.character.pattern) * width / CLIPS_PER_ROW, 0 * height / CLIPS_PER_COLUMN, width / CLIPS_PER_ROW, height / CLIPS_PER_COLUMN)
        instance.quad = lg.newQuad(instance.rectangle.x, instance.rectangle.y, instance.rectangle.width, instance.rectangle.height, width, height)
    else
        instance.rectangle = Rectangle.set(instance.rectangle, 0, 0, LOGICAL_GRID_SIZE, LOGICAL_GRID_SIZE)
    end

    instance.x = instance.character.rx - Game.stage.displayx * LOGICAL_GRID_SIZE
    instance.y = REFERENCE_HEIGHT - instance.character.ry + Game.stage.displayy * LOGICAL_GRID_SIZE

    instance.opacity = instance.character.opacity
    instance.visible = not instance.character.transparent
    SpriteBase.afterUpdate(instance, dt)
end

function SpriteCharacter.render(instance)
    SpriteBase.beforeRender(instance)
    if instance.image then
        lg.drawq(instance.image, instance.quad, instance.x, instance.y)
    else
        lg.push()
        lg.translate(instance.rectangle.width * 0.5, instance.rectangle.height * 0.5)
        lg.setColor(193, 47, 14, 255)
        lg.circle('fill', instance.x, instance.y, LOGICAL_GRID_SIZE * 0.5)
        lg.pop()
    end
    SpriteBase.afterRender(instance)
end

return SpriteCharacter
