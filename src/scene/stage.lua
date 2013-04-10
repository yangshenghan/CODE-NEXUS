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
local NEXUS_KEY             = Constants.KEYS
local NEXUS_EMPTY_FUNCTION  = Constants.EMPTY_FUNCTION

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
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SceneStage.new(name)
    local instance = SceneBase.new(SceneStage)
    instance.name = name
    instance.sprites = {}
    instance.viewports = {}
    return SceneLoading.new(instance)
end

function SceneStage.enter(instance)
    -- Load stage data
    instance.map = Data.loadMapData(instance.name)
    instance.stage = Game.stage.load(instance.name)
    instance.script = Data.loadScriptData(instance.name)

    -- Initialize stage
    table.insert(instance.viewports, Viewport.new())
    table.insert(instance.viewports, Viewport.new())
    table.insert(instance.viewports, Viewport.new())

    instance.viewports[1].z = 10
    instance.viewports[2].z = 20
    instance.viewports[3].z = 30

    table.insert(instance.sprites, SpriteCharacter.new(instance.viewports[2], Game.player))

    -- Create objects
    instance.objects = {}
    for _, data in pairs(instance.stage.objects) do
        local object = {}
        object = data
        object.z = 10
        object.dispose = NEXUS_EMPTY_FUNCTION
        object.isDisposed = NEXUS_EMPTY_FUNCTION
        object.isVisible = function() return true end
        object.update = data.update or NEXUS_EMPTY_FUNCTION
        object.render = data.render or NEXUS_EMPTY_FUNCTION
        object.viewport = instance.viewports[2]
        Graphics.addDrawable(object)
        table.insert(instance.objects, object)
    end
end

function SceneStage.leave(instance)
    instance.viewports = nil
    instance.sprites = nil
    instance.objects = nil
    Game.player = nil
    instance.script = nil
    instance.stage = nil
    instance.map = nil
end

function SceneStage.update(instance, dt)
    if instance.idle then return end

    if Input.isKeyDown(NEXUS_KEY.Z) then
        Game.player.rush(Game.player)
    end

    if Input.isKeyDown(NEXUS_KEY.X) then
        Game.player.jump(Game.player)
    end

    if Input.isKeyDown(NEXUS_KEY.C) then
        Game.player.attack(Game.player)
    end

    if Input.isKeyDown(NEXUS_KEY.LEFT) and GameObject.isPassable(Game.player, Game.player.x - 1, Game.player.y) then
        Game.player.left(Game.player)
    end

    if Input.isKeyDown(NEXUS_KEY.RIGHT) and GameObject.isPassable(Game.player, Game.player.x + 1, Game.player.y) then
        Game.player.right(Game.player)
    end

    if Input.isKeyDown(NEXUS_KEY.UP) and GameObject.isPassable(Game.player, Game.player.x, Game.player.y + 1) then
        Game.player.up(Game.player)
    end

    if Input.isKeyDown(NEXUS_KEY.DOWN) and GameObject.isPassable(Game.player, Game.player.x, Game.player.y - 1) then
        Game.player.down(Game.player)
    end

    Game.player.update(Game.player, dt)

    for _, object in pairs(instance.objects) do
        object.update(object, dt)
    end

    for _, sprite in ipairs(instance.sprites) do
        sprite.update(sprite)
    end
end

function SceneStage.__debug(instance)
    local messages = { 'SceneStage' }
    if Game.player then
        table.insert(messages, string.format('Player location: <%d, %d> (%d, %d)', Game.player.x, Game.player.y, Game.player.rx, Game.player.ry))
    end
    return messages
end

return SceneStage
