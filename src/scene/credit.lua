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
local ipairs                = ipairs
local unpack                = unpack
local Nexus                 = nexus
local Core                  = Nexus.core
local Viewport              = Core.import 'nexus.base.data'
local Data                  = Core.import 'nexus.core.data'
local Resource              = Core.import 'nexus.core.resource'
local SpriteCredit          = Core.import 'nexus.sprite.credit'
local SpritePicture         = Core.import 'nexus.sprite.picture'
local SceneBase             = Core.import 'nexus.scene.base'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SceneCredit           = {
    sprites                 = nil
}

local CREDIT_PICTURES       = {}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function create_picture_sprite(x, y, filename)
    local sprite = SpritePicture.new(viewport_for_pictures, filename)
    sprite.x = x
    sprite.y = y
    sprite.opacity = 0
    sprite.visible = false
    sprite.visible = false
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SceneCredit.new()
    local instance = SceneBase.new(SceneCredit)
    return instance
end

function SceneCredit.enter(instance)
    local viewport_for_pictures = Viewport.new(10)
    instance.sprites = {
        SpriteCredit.new(Data.getTerm('credits'), nil, Viewport.new(15))
    }

    for _, picture in ipairs(CREDIT_PICTURES) do
        table.insert(instance.sprites, create_picture_sprite(unpack(picture)))
    end
end

function SceneCredit.leave(instance)
    for _, sprite in ipairs(instance.sprites) do sprite.dispose(sprite) end
end

function SceneCredit.update(instance, dt)
    if instance.idle then return end

    for _, sprite in ipairs(instance.sprites) do sprite.update(sprite, dt) end
end

function SceneCredit.__debug(instance)
    local string = string

    return {
        'SceneCredit',
        string.format('Credit sprite location: <%d, %d>', instance.sprite.x, instance.sprite.y)
    }
end

return SceneCredit
