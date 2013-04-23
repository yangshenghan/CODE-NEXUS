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
local coroutine             = coroutine
local Nexus                 = nexus
local Core                  = Nexus.core
local Viewport              = Core.import 'nexus.base.viewport'
local Data                  = Core.import 'nexus.core.data'
local Resource              = Core.import 'nexus.core.resource'
local SpriteCredit          = Core.import 'nexus.sprite.credit'
local SpritePicture         = Core.import 'nexus.sprite.picture'
local SceneBase             = Core.import 'nexus.scene.base'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SceneCredit           = {
    current                 = nil,
    sprites                 = nil,
    pictures                = nil,
    coroutines              = nil,
    index                   = 0
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function create_picture_sprite(viewport, x, y, filename)
    local sprite = SpritePicture.new(viewport, filename)
    sprite.x = x
    sprite.y = y
    sprite.opacity = 0
    sprite.visible = false
    return sprite
end

local function update_timing_control(instance, dt)
    while true do
        coroutine.yield()
    end
end

local function update_picture_transition(instance, dt)
    while true do
        local index = instance.index
        if index > 1 and instance.current ~= instance.sprites[index] then
            local sprite = instance.sprites[index]
            local current = instance.current
            sprite.visible = true
            while sprite.opacity < 1 do
                if current then current.opacity = current.opacity - 0.05 end
                sprite.opacity = sprite.opacity + 0.05
                coroutine.yield()
            end
            instance.current = sprite
        end
        coroutine.yield()
    end
end

local function update_all_sprites(instance, dt)
    while true do
        for _, sprite in ipairs(instance.sprites) do sprite.update(sprite, dt) end
        coroutine.yield()
    end
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SceneCredit.new()
    local instance = SceneBase.new(SceneCredit)
    return instance
end

function SceneCredit.enter(instance)
    local pictures = Data.getSystem('credits')
    local viewport_for_pictures = Viewport.new(10)

    instance.index = 1
    instance.sprites = {
        SpriteCredit.new(Data.getTerm('credits'), nil, Viewport.new(15))
    }

    instance.coroutines = {
        coroutine.create(update_timing_control),
        coroutine.create(update_picture_transition),
        coroutine.create(update_all_sprites)
    }

    for _, picture in ipairs(pictures) do
        table.insert(instance.sprites, create_picture_sprite(viewport_for_pictures, unpack(picture)))
    end
end

function SceneCredit.leave(instance)
    for _, sprite in ipairs(instance.sprites) do sprite.dispose(sprite) end
    instance.coroutines = nil
    instance.sprites = nil
end

function SceneCredit.update(instance, dt)
    if instance.idle then return end

    for _, operation in ipairs(instance.coroutines) do coroutine.resume(operation, instance, dt) end
end

function SceneCredit.showNextPicture(instance)
    instance.index = (instance.index + 1) % (#instance.sprites + 1)
end

function SceneCredit.__debug(instance)
    local string = string
    local messages = {
        'SceneCredit',
        string.format('Picture index: %d', instance.index)
    }

    for index, sprite in ipairs(instance.sprites) do
        table.insert(messages, string.format('Sprite #%d: <%d, %d> (%f, %s)', index, sprite.x, sprite.y, sprite.opacity, sprite.visible and 'visible' or 'invisible'))
    end

    return messages
end

return SceneCredit
