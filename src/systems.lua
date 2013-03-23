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
-- | Local variables                                                        | --
-- |   These entities should not be changed at runtime.                     | --
-- \ ---------------------------------------------------------------------- / --
local t_systems             = {
    version                 = {
        major               = '0',
        minor               = '2',
        micro               = '0',
        patch               = '0',
        build               = '0',
        stamp               = '20130315',
        stage               = 'Development',
    },
    paths                   = {
        identity            = 'code-nexus',
        configure           = 'config.dat',
        saving              = 'save-%02d.sav'
    },
    defaults                = {
        width               = 640,
        height              = 360,
        fullscreen          = false
    },
    parameters              = {
        saving_slot_size        = 15,
        logical_grid_size       = 16,
        logical_canvas_width    = 1280,
        logical_canvas_height   = 720,
        configure_identifier    = 'configure'
    },
    debug                   = true,
    firstrun                = false,
    error                   = nil
}

return t_systems
