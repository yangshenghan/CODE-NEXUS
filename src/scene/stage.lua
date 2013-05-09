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
local Game                  = Core.import 'nexus.core.game'
local Scene                 = Core.import 'nexus.core.scene'
local Resource              = Core.import 'nexus.core.resource'
local Viewport              = Core.import 'nexus.base.viewport'
local SceneBase             = Core.import 'nexus.scene.base'
local SceneLoading          = Core.import 'nexus.scene.loading'
local SpriteCharacter       = Core.import 'nexus.sprite.character'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SceneStage            = {
    sprites                 = nil,
    viewports               = nil
}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local RESOURCE_LOADERS      = {
    effects                 = Resource.loadEffectSource,
    musics                  = Resource.loadMusicSource,
    sounds                  = Resource.loadSoundSource,
    animations              = Resource.loadAnimationIamge,
    characters              = Resource.loadCharacterImage,
    icons                   = Resource.loadIconImage,
    maps                    = Resource.loadMapImage,
    objects                 = Resource.loadObjectImage,
    pictures                = Resource.loadPictureImage,
    systems                 = Resource.loadSystemImage,
    fonts                   = Resource.loadFontData,
    glyphs                  = Resource.loadGlyphData,
    videos                  = Resource.loadVideoData
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function load_stage_resources(resources, callback)
    for name, loader in pairs(RESOURCE_LOADERS) do
        if resources[name] then
            for _, resource in ipairs(resources[name]) do
                loader(resource)
                callback(name, resource)
            end
        end
    end
end

local function create_stage_viewports(instance)
    table.insert(instance.viewports, Viewport.new(10))
    table.insert(instance.viewports, Viewport.new(20))
    table.insert(instance.viewports, Viewport.new(30))
end

local function create_character_sprites(instance)
    instance.sprites.characters = {}

    table.insert(instance.sprites.characters, SpriteCharacter.new(instance.viewports[2], Game.player))
end

local function create_stage_spriteset(instance)
    instance.sprites = {}
    instance.viewports = {}

    create_stage_viewports(instance)
    create_character_sprites(instance)
end

local function update_character_sprites(instance)
    for _, sprite in ipairs(instance.sprites.characters) do
        sprite.update(sprite)
    end
end

local function update_stage_viewports(instance)
end

local function update_stage_spriteset(instance)
    update_character_sprites(instance)
    update_stage_viewports(instance)
end

local function dispose_character_sprites(instance)
    for _, sprite in ipairs(instance.sprites.characters) do
        sprite.dispose(sprite)
    end
end

local function dispose_stage_viewports(instance)
    for _, viewport in ipairs(instance.viewports) do
        viewport.dispose(viewport)
    end
end

local function dispose_stage_spriteset(instance)
    dispose_character_sprites(instance)
    dispose_stage_viewports(instance)

    instance.viewports = nil
    instance.sprites = nil
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SceneStage.new(name)
    local instance = SceneBase.new(SceneStage)
    instance.name = name
    return SceneLoading.new(instance)
end

function SceneStage.enter(instance)
    local Constants         = Nexus.constants
    local Graphics          = Core.import 'nexus.core.graphics'
    local EMPTY_FUNCTION    = Constants.EMPTY_FUNCTION

    local progress = 0
    local total_resource_size = 0

    local map = Game.map.load(instance.name)
    local stage = Game.stage.load(instance.name)
    local script = Game.script.load(instance.name)

    table.foreach(stage.resources, function(_, resources)
        total_resource_size = total_resource_size + #resources
    end)

    load_stage_resources(stage.resources, function(name, resource)
        progress = progress + 1
        SceneLoading.setProgress(progress / total_resource_size, string.format('Now loading: %s.%s', name, resource))
    end)

    create_stage_spriteset(instance)

    Game.stage.enableKeyBindings()
    -- for _, spawn in pairs(stage.spawns) do
    for _, spawn in pairs(stage.objects) do
        local object = {}
        object = spawn
        object.z = 10
        object.dispose = EMPTY_FUNCTION
        object.isDisposed = EMPTY_FUNCTION
        object.isVisible = function() return true end
        object.update = spawn.update or EMPTY_FUNCTION
        object.render = spawn.render or EMPTY_FUNCTION
        object.viewport = viewport
        Graphics.addDrawable(object)
        Game.stage.spawn(object)
    end
end

function SceneStage.leave(instance)
    dispose_stage_spriteset(instance)

    Game.stage.disableKeyBindings()

    Game.stage.unload()
end

function SceneStage.update(instance, dt)
    if instance.idle then return end

    Game.stage.update(dt)
    Game.player.update(dt)
    update_stage_spriteset(instance)
end

function SceneStage.__debug(instance)
    local string = string
    local messages = { 'SceneStage' }
    local Constants = Nexus.constants
    local LOGICAL_GRID_SIZE = Constants.LOGICAL_GRID_SIZE

    if Game.player then
        local sprite = table.last(instance.sprites.characters)
        table.insert(messages, string.format('Display area: <%d, %d> (%d, %d)', Game.map.displayx, Game.map.displayy, Game.map.displayx * LOGICAL_GRID_SIZE, Game.map.displayy * LOGICAL_GRID_SIZE))
        table.insert(messages, string.format('Player location: <%d, %d> (%d, %d)', Game.player.x, Game.player.y, Game.player.rx, Game.player.ry))
        table.insert(messages, string.format('Player location (Sprite): <%s, %d>', sprite.x, sprite.y))
    end

    return messages
end

return SceneStage
