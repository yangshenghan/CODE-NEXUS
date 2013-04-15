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

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Scene                 = {}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local t_scenes              = {}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Scene.initialize()
end

function Scene.finalize()
    while #t_scenes > 0 do Scene.leave() end

    t_scenes = {}
end

function Scene.update(dt)
    for _, scene in ipairs(t_scenes) do scene.update(scene, dt) end
end

function Scene.pause()
    local scene = Scene.getCurrentScene()
    scene.setIdle(scene, true)
    scene.idleIn(current)
end

function Scene.resume()
    local scene = Scene.getCurrentScene()
    scene.setIdle(scene, false)
    scene.idleOut(current)
end

function Scene.getCurrentScene()
    return table.last(t_scenes)
end

function Scene.change(scene)
    t_scenes[#t_scenes] = scene
end

function Scene.goto(scene)
    if #t_scenes > 0 then Scene.leave() end
    Scene.enter(scene)
end

function Scene.enter(scene)
    if #t_scenes > 0 then
        local current = Scene.getCurrentScene()
        current.setIdle(current, true)
        current.idleIn(current)
    end

    table.insert(t_scenes, scene)
    scene.enter(scene)
end

function Scene.leave()
    if #t_scenes == 0 then return end

    local last = table.remove(t_scenes)
    last.leave(last)

    if #t_scenes > 0 then
        local current = Scene.getCurrentScene()
        current.setIdle(current, false)
        current.idleOut(current)
    end
end

return Scene
