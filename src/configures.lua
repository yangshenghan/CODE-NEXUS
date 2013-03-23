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
-- \ ---------------------------------------------------------------------- / --
local t_configures          = {
    audios                  = {
        volume              = 80
    },
    keyboards               = {
        z                   = {'z'},
        x                   = {'x'},
        c                   = {'c'},
        v                   = {'v'},
        a                   = {'a'},
        s                   = {'s'},
        d                   = {'d'},
        f                   = {'f'},
        up                  = {'up'},
        right               = {'right'},
        down                = {'down'},
        left                = {'left'},
        confirm             = {'return'},
        cancel              = {'escape'}
    },
    gameplay                = {
    },
    joysticks               = {
    },
    mouses                  = {
    },
    graphics                = {
        width               = 1280,
        height              = 720,
        fullscreen          = false,
        vsync               = true,
        fsaa                = 0
    },
    options                 = {
        language            = 'en_US'
    }
}

return t_configures
