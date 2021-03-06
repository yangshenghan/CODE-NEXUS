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
local Nexus                 = nexus
local Core                  = Nexus.core
local Game                  = Core.import 'nexus.core.game'
local Scene                 = Core.import 'nexus.core.scene'
local SceneBase             = Core.import 'nexus.scene.base'
local SceneStage            = Core.import 'nexus.scene.stage'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local SceneNewGame          = {}

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function SceneNewGame.new()
    local instance = SceneBase.new(SceneNewGame)
    return instance
end

function SceneNewGame.enter(instance)
    Game.setup()
    Scene.goto(SceneStage.new('prologue'))
end

function SceneNewGame.leave(instance)
end

function SceneNewGame.update(instance, dt)
    if instance.idle then return end
end

return SceneNewGame
