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
local math                  = math
local Nexus                 = nexus
local Core                  = Nexus.core
local Scene                 = Core.import 'nexus.core.scene'
local SceneBase             = Core.import 'nexus.scene.base'
local WindowProgressBar     = Core.import 'nexus.window.progressbar'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SceneLoading          = {
    scene                   = nil
}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SceneLoading.new(scene)
    local instance = SceneBase.new(SceneLoading)
    instance.scene = scene
    return instance
end

function SceneLoading.enter(instance)
    instance.scene.loading = instance
    instance.scene.progress = WindowProgressBar.new()
    instance.scene.coroutine = coroutine.create(instance.scene.enter)
end

function SceneLoading.update(instance, dt)
    if instance.idle then return end

    local _, progress, text = coroutine.resume(instance.scene.coroutine, instance.scene, dt)
    instance.scene.progress.setProgressText(instance.scene.progress, text)
    instance.scene.progress.setProgressValue(instance.scene.progress, progress)

    if coroutine.status(instance.scene.coroutine) == 'dead' then
        instance.scene.progress.dispose(instance.scene.progress)

        Scene.change(instance.scene)
        instance.scene = nil
    end
end

function SceneLoading.setProgress(value, text)
    coroutine.yield(value, text)
end

return SceneLoading
