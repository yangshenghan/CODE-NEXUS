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

nexus.base = {}
nexus.scene = {}
nexus.object = {}
nexus.sprite = {}
nexus.window = {}

require 'src.game'

require 'src.core.audio'
require 'src.core.database'
require 'src.core.graphics'
require 'src.core.input'
require 'src.core.message'
require 'src.core.resource'
require 'src.core.scene'

require 'src.base.color'
require 'src.base.scene'
require 'src.base.object'
require 'src.base.window'

require 'src.scene.error'
require 'src.scene.console'
require 'src.scene.loading'
require 'src.scene.title'
require 'src.scene.newgame'
require 'src.scene.continue'
require 'src.scene.stage'
require 'src.scene.option'
require 'src.scene.extra'
require 'src.scene.exit'

require 'src.object.player'

require 'src.window.command'
