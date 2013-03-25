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
local nexus                 = nexus

nexus.scene.stage           = {}

local require               = require

local Data                  = require 'src.core.data'
local Game                  = require 'src.core.game'
local Graphics              = require 'src.core.graphics'
local Input                 = require 'src.core.input'
local Scene                 = require 'src.core.scene'
local Viewport              = require 'src.base.viewport'

local NEXUS_KEY             = NEXUS_KEY

local NEXUS_EMPTY_FUNCTION  = NEXUS_EMPTY_FUNCTION

local function enter(instance)
    local canvas = love.graphics.newCanvas()
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
        love.graphics.draw(canvas)
    end
    love.graphics.setCanvas(canvas)
    love.graphics.setBlendMode('premultiplied')
    love.graphics.setColor(255, 255, 255, 32)
    for j = 0, 45 do
        for i = 0, 80 do
            love.graphics.rectangle('line', 16 * i, 16 * j, 16, 16)
        end
    end
    love.graphics.setBlendMode('alpha')
    love.graphics.setCanvas()
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

local function leave(instance)
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

local function update(instance, dt)
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

function nexus.scene.stage.getCurrentStage()
    local scene = Scene.getCurrentScene()
    return scene.stage
end

function nexus.scene.stage.new(name)
    return nexus.scene.loading.new({
        enter   = enter,
        leave   = leave,
        update  = update,
        name    = name
    })
end
