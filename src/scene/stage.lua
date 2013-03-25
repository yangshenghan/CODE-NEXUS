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
local SceneBase             = Core.import 'nexus.scene.base'
local SceneLoading          = Core.import 'nexus.scene.loading'
local NEXUS_KEY             = Constants.KEYS
local NEXUS_EMPTY_FUNCTION  = Constants.EMPTY_FUNCTION

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SceneStage            = {
    map                     = nil,
    stage                   = nil,
    script                  = nil
}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SceneStage.new(name)
    local instance = SceneBase.new(SceneStage)
    instance.name = name
    return SceneLoading.new(instance)
end

function SceneStage.enter(instance)
    local canvas = lg.newCanvas()
    local background = Graphics.getBackgroundViewport()
    instance.gameobjects = Game.getGameObjects()

    -- Load stage data
    instance.map = Data.loadMapData(instance.name)
    instance.stage = Data.loadStageData(instance.name)
    instance.script = Data.loadScriptData(instance.name)

    -- Initialize stage
    instance.player = instance.gameobjects.player
    instance.player.z = 30
    instance.player.visible = true
    instance.player.dispose = NEXUS_EMPTY_FUNCTION
    instance.player.disposed = NEXUS_EMPTY_FUNCTION
    instance.objects = { instance.player }
    instance.viewports = {
        Viewport.new(),
        Viewport.new(),
        Viewport.new()
    }
    instance.viewports[1].z = 10
    instance.viewports[2].z = 20
    instance.viewports[3].z = 30

    -- Draw basic grid for easy developing
    background.x = 0
    background.y = 0
    background.visible = true
    background.dispose = NEXUS_EMPTY_FUNCTION
    background.disposed = NEXUS_EMPTY_FUNCTION
    background.render = function(instance)
        Graphics.clear()
        lg.draw(canvas)
    end
    lg.setCanvas(canvas)
    lg.setBlendMode('premultiplied')
    lg.setColor(255, 255, 255, 32)
    for j = 0, 45 do
        for i = 0, 80 do
            lg.rectangle('line', 16 * i, 16 * j, 16, 16)
        end
    end
    lg.setBlendMode('alpha')
    lg.setCanvas()
    Viewport.addDrawable(instance.viewports[1], instance.player)
    Viewport.addDrawable(Graphics.getBackgroundViewport(), background)

    -- Create objects
    for _, data in pairs(instance.stage.objects) do
        local object = {}
        object = data
        object.z = 10
        object.visible = true
        object.dispose = NEXUS_EMPTY_FUNCTION
        object.disposed = NEXUS_EMPTY_FUNCTION
        object.update = data.update or NEXUS_EMPTY_FUNCTION
        object.render = data.render or NEXUS_EMPTY_FUNCTION
        Viewport.addDrawable(instance.viewports[1], object)
        table.insert(instance.objects, object)
    end
end

function SceneStage.leave(instance)
    instance.player.delete(instance.player)

    for _, viewport in pairs(instance.viewports) do
        Viewport.dispose(viewport)
    end

    instance.gameobjects = nil
    instance.objects = nil
    instance.player = nil
    instance.script = nil
    instance.stage = nil
    instance.map = nil
end

function SceneStage.update(instance, dt)
    if instance.idle then return end

    if Input.isKeyDown(NEXUS_KEY.Z) then
        instance.player.rush(instance.player)
    end

    if Input.isKeyDown(NEXUS_KEY.X) then
        instance.player.jump(instance.player)
    end

    if Input.isKeyDown(NEXUS_KEY.C) then
        instance.player.attack(instance.player)
    end

    if Input.isKeyDown(NEXUS_KEY.LEFT) and nexus.base.object.isPassable(instance.player, instance.player.object.x - 1, instance.player.object.y) then
        instance.player.left(instance.player)
    end

    if Input.isKeyDown(NEXUS_KEY.RIGHT) and nexus.base.object.isPassable(instance.player, instance.player.object.x + 1, instance.player.object.y) then
        instance.player.right(instance.player)
    end

    if Input.isKeyDown(NEXUS_KEY.UP) and nexus.base.object.isPassable(instance.player, instance.player.object.x, instance.player.object.y + 1) then
        instance.player.up(instance.player)
    end

    if Input.isKeyDown(NEXUS_KEY.DOWN) and nexus.base.object.isPassable(instance.player, instance.player.object.x, instance.player.object.y - 1) then
        instance.player.down(instance.player)
    end

    for _, object in pairs(instance.objects) do
        object.update(object, dt)
    end
end

function SceneStage.getCurrentStage()
    local scene = Scene.getCurrentScene()
    return scene.stage
end

return SceneStage
