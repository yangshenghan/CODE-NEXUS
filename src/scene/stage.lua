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
local l                     = love
local lg                    = l.graphics
local Nexus                 = nexus
local Core                  = Nexus.core
local Constants             = Nexus.constants
local Data                  = Core.import 'nexus.core.data'
local Game                  = Core.import 'nexus.core.game'
local Graphics              = Core.import 'nexus.core.graphics'
local Input                 = Core.import 'nexus.core.input'
local Scene                 = Core.import 'nexus.core.scene'
local Viewport              = Core.import 'nexus.base.viewport'
local GameObject            = Core.import 'nexus.game.object'
local SceneBase             = Core.import 'nexus.scene.base'
local SceneLoading          = Core.import 'nexus.scene.loading'
local SpriteCharacter       = Core.import 'nexus.sprite.character'
local KEYS                  = Constants.KEYS
local EMPTY_FUNCTION  = Constants.EMPTY_FUNCTION

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SceneStage            = {
    map                     = nil,
    stage                   = nil,
    script                  = nil,
    sprites                 = nil,
    viewports               = nil
}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                     | --
-- \ ---------------------------------------------------------------------- / --
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
    -- Load stage data
    instance.map = Data.loadMapData(instance.name)
    instance.stage = Game.stage.load(instance.name)
    instance.script = Data.loadScriptData(instance.name)

    -- Initialize stage
    create_stage_spriteset(instance)

    -- Create objects
    instance.objects = {}
    for _, data in pairs(instance.stage.objects) do
        local object = {}
        object = data
        object.z = 10
        object.dispose = EMPTY_FUNCTION
        object.isDisposed = EMPTY_FUNCTION
        object.isVisible = function() return true end
        object.update = data.update or EMPTY_FUNCTION
        object.render = data.render or EMPTY_FUNCTION
        object.viewport = instance.viewports[2]
        Graphics.addDrawable(object)
        table.insert(instance.objects, object)
    end
end

function SceneStage.leave(instance)
    dispose_stage_spriteset(instance)

    instance.objects = nil
    instance.script = nil
    instance.stage = nil
    instance.map = nil
end

function SceneStage.update(instance, dt)
    if instance.idle then return end

    if Input.isKeyDown(KEYS.Z) then
        Game.player.rush(Game.player)
    end

    if Input.isKeyDown(KEYS.X) then
        Game.player.jump(Game.player)
    end

    if Input.isKeyDown(KEYS.C) then
        Game.player.attack(Game.player)
    end

    if Input.isKeyDown(KEYS.LEFT) and GameObject.isPassable(Game.player, Game.player.x - 1, Game.player.y) then
        Game.player.left(Game.player)
    end

    if Input.isKeyDown(KEYS.RIGHT) and GameObject.isPassable(Game.player, Game.player.x + 1, Game.player.y) then
        Game.player.right(Game.player)
    end

    if Input.isKeyDown(KEYS.UP) and GameObject.isPassable(Game.player, Game.player.x, Game.player.y + 1) then
        Game.player.up(Game.player)
    end

    if Input.isKeyDown(KEYS.DOWN) and GameObject.isPassable(Game.player, Game.player.x, Game.player.y - 1) then
        Game.player.down(Game.player)
    end

    Game.player.update(Game.player, dt)

    for _, object in pairs(instance.objects) do
        object.update(object, dt)
    end

    update_stage_spriteset(instance)
end

function SceneStage.__debug(instance)
    local string = string
    local messages = { 'SceneStage' }
    local LOGICAL_GRID_SIZE = Constants.LOGICAL_GRID_SIZE

    if Game.player then
        local sprite = table.last(instance.sprites.characters)
        table.insert(messages, string.format('Display area: <%d, %d> (%d, %d)', Game.stage.displayx, Game.stage.displayy, Game.stage.displayx * LOGICAL_GRID_SIZE, Game.stage.displayy * LOGICAL_GRID_SIZE))
        table.insert(messages, string.format('Player location: <%d, %d> (%d, %d)', Game.player.x, Game.player.y, Game.player.rx, Game.player.ry))
        table.insert(messages, string.format('Player location (Sprite): <%s, %d>', sprite.x, sprite.y))
    end

    return messages
end

return SceneStage
