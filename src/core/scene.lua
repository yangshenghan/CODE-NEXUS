--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-18                                                    ]]--
--[[ License: zlib/libpng License                                           ]]--
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
nexus.core.scene = {}

local t_current = nil

local t_scenes = {}

function nexus.core.scene.initialize()
end

function nexus.core.scene.finalize()
    t_current = nil

    nexus.core.scene.clear()
end

function nexus.core.scene.update(dt)
    if t_current then
        t_current.update(t_current, dt)
    end

    for _, scene in ipairs(t_scenes) do
        if not nexus.base.scene.isIdle(scene) then
            scene.update(scene, dt)
        end
    end
end

function nexus.core.scene.render()
    if t_current then
        t_current.render(t_current)
    end

    for _, scene in ipairs(t_scenes) do
        scene.render(scene)
    end
end

function nexus.core.scene.pause()
    nexus.base.scene.setIdle(t_current, true)
end

function nexus.core.scene.resume()
    nexus.base.scene.setIdle(t_current, false)
end

function nexus.core.scene.clear()
    while #t_scenes > 0 do
        nexus.core.scene.leave()
    end

    t_scenes = {}
end

function nexus.core.scene.getCurrentScene()
    return t_current
end

function nexus.core.scene.goto(scene)
    if t_current then
        t_current.leave(t_current)
    end
    t_current = scene
    if t_current then
        t_current.enter(t_current)
    end
end

function nexus.core.scene.enter(scene)
    if #t_scenes > 0 then
        local last = table.last(t_scenes)
        nexus.base.scene.setIdle(last, true)
        last.idleIn(last)
    elseif t_current then
        nexus.base.scene.setIdle(t_current, true)
        t_current.idleIn(t_current)
    end

    table.insert(t_scenes, scene)
    scene.enter(scene)
end

function nexus.core.scene.leave()
    if #t_scenes == 0 then
        return
    end

    local popped = table.remove(t_scenes)
    popped.leave(popped)

    if #t_scenes > 0 then
        local last = table.last(t_scenes)
        nexus.base.scene.setIdle(last, false)
        last.idleOut(last)
    elseif t_current then
        nexus.base.scene.setIdle(t_current, false)
        t_current.idleOut(t_current)
    end
end

