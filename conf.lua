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
-- | Global constant definitions                                            | --
-- \ ---------------------------------------------------------------------- / --
NEXUS_KEY = {
    Z           = 'z',
    X           = 'x',
    C           = 'c',
    V           = 'v',
    A           = 'a',
    S           = 's',
    D           = 'd',
    F           = 'f',
    UP          = 'up',
    RIGHT       = 'right',
    DOWN        = 'down',
    LEFT        = 'left',
    CONFIRM     = 'confirm',
    CANCEL      = 'cancel',
    SHIFT       = 'shift',
    ALTERNATIVE = 'alternative',
    CONTROL     = 'control',
    F1          = 'f1',
    F2          = 'f2',
    F3          = 'f3',
    F4          = 'f4',
    F5          = 'f5',
    F6          = 'f6',
    F7          = 'f7',
    F8          = 'f8'
}

NEXUS_EMPTY_FUNCTION = function(...) end

-- / ---------------------------------------------------------------------- \ --
-- | Construction of base nexus table                                       | --
-- \ ---------------------------------------------------------------------- / --
nexus = {
    base = {},
    core = {},
    game = {},
    scene = {},
    sprite = {},
    system = {},
    window = {},

    systems                 = {  -- these should not be changed at runtime.
        version             = {
            major           = '0',
            minor           = '2',
            micro           = '0',
            patch           = '0',
            build           = '0',
            stamp           = '20130315',
            stage           = 'Development',
        },
        paths               = {
            identity        = 'code-nexus',
            configure       = 'config.dat',
            saving          = 'save-%02d.sav'
        },
        defaults            = {
            width           = 640,
            height          = 360,
            fullscreen      = false
        },
        parameters          = {
            saving_slot_size        = 15,
            logical_grid_size       = 16,
            logical_canvas_width    = 1280,
            logical_canvas_height   = 720,
            configure_identifier    = 'configure'
        },
        debug               = true,
        firstrun            = false,
        error               = nil
    },
    settings                = {
        showfps             = true,
        console             = false,
        level               = 5
    },
    configures              = {
        audios              = {
            volume          = 80
        },
        keyboards           = {
            z               = {'z'},
            x               = {'x'},
            c               = {'c'},
            v               = {'v'},
            a               = {'a'},
            s               = {'s'},
            d               = {'d'},
            f               = {'f'},
            up              = {'up'},
            right           = {'right'},
            down            = {'down'},
            left            = {'left'},
            confirm         = {'return'},
            cancel          = {'escape'}
        },
        gameplay            = {
        },
        joysticks           = {
        },
        mouses              = {
        },
        graphics            = {
            width           = 1280,
            height          = 720,
            fullscreen      = false,
            vsync           = true,
            fsaa            = 0
        },
        options             = {
            language        = 'en_US'
        }
    }
}

-- / ---------------------------------------------------------------------- \ --
-- | Entry point of LÖVE before modules are loaded                          | --
-- \ ---------------------------------------------------------------------- / --
local nexus                 = nexus

function love.conf(game)
    local identity  = nexus.systems.paths.identity
    local filename  = nexus.systems.paths.configure
    local f_save    = require 'src.system.save'
    local f_read    = require 'src.system.read'
    local f_exists  = require 'src.system.exists'

    love.filesystem.setIdentity(identity)
    if not f_exists(filename) then
        f_save(filename, nexus.configures, nexus.systems.parameters.configure_identifier)
        nexus.systems.firstrun = true
    end
    nexus.configures = f_read(filename)

    game.title = 'CODE NEXUS'
    if nexus.systems.debug then
        game.title = 'CODE NEXUS ' .. nexus.systems.version.stage .. ' (Build ' .. nexus.systems.version.build .. ' - ' .. nexus.systems.version.stamp .. ')'
    end
    game.author = 'Yang Sheng Han'
    game.url = 'http://yangshenghan.twbbs.org'
    game.version = '0.8.0'
    game.release = not nexus.systems.debug

    game.modules.physics = false

    game.screen.width = nexus.systems.defaults.width
    game.screen.height = nexus.systems.defaults.height
    game.screen.fullscreen = nexus.systems.defaults.fullscreen

    if nexus.configures.graphics then
        game.screen.width = nexus.configures.graphics.width
        game.screen.height = nexus.configures.graphics.height
        game.screen.fullscreen = nexus.configures.graphics.fullscreen
        game.screen.vsync = nexus.configures.graphics.vsync
        game.screen.fsaa = nexus.configures.graphics.fsaa
    end
end
