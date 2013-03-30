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
local require               = require

-- / ---------------------------------------------------------------------- \ --
-- | Construction of the nexus table                                        | --
-- \ ---------------------------------------------------------------------- / --
nexus = {
    core                    = {
        read                = require 'src.system.read',
        save                = require 'src.system.save',
        load                = require 'src.system.load',
        exists              = require 'src.system.exists',
        import              = require 'src.system.import',
        upgrade             = require 'src.system.upgrade',
        version             = require 'src.system.version'
    },
    constants               = {
        KEYS                = {
            Z               = 'z',
            X               = 'x',
            C               = 'c',
            V               = 'v',
            A               = 'a',
            S               = 's',
            D               = 'd',
            F               = 'f',
            UP              = 'up',
            RIGHT           = 'right',
            DOWN            = 'down',
            LEFT            = 'left',
            CONFIRM         = 'confirm',
            CANCEL          = 'cancel',
            SHIFT           = 'shift',
            ALTERNATIVE     = 'alternative',
            CONTROL         = 'control',
            F1              = 'f1',
            F2              = 'f2',
            F3              = 'f3',
            F4              = 'f4',
            F5              = 'f5',
            F6              = 'f6',
            F7              = 'f7',
            F8              = 'f8',
            F9              = 'f9',
            F10             = 'f10',
            F11             = 'f11',
            F12             = 'f12'
        },
        VERSION             = {
            MAJOR           = '0',
            MINOR           = '3',
            MICRO           = '0',
            PATCH           = '0',
            BUILD           = '0',
            STAMP           = '20130328',
            STAGE           = 'Development'
        },
        PATHS               = {
            CONFIGURE       = 'config.dat',
            SAVING          = 'save-%02d.sav'
        },
        DEBUG_MODE          = true,
        FIRST_RUN           = false,
        EMPTY_FUNCTION      = function(...) end,
        SAVING_SLOT_SIZE    = 15,
        LOGICAL_GRID_SIZE   = 16,
        CONFIGURE_IDENTIFIER= 'configure',
        REFERENCE_WIDTH     = 1280,
        REFERENCE_HEIGHT    = 720,
        FALLBACK_WIDTH      = 640,
        FALLBACK_HEIGHT     = 360
    },
    configures              = {
        audios              = {
            volume          = 80
        },
        mouses              = {
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
            confirm         = {'return', ' '},
            cancel          = {'escape'},
            shift           = {'lshift', 'rshift'},
            alternative     = {'lalt', 'ralt'},
            control         = {'lctrl', 'rctrl'},
            f1              = {'f1'},
            f2              = {'f2'},
            f3              = {'f3'},
            f4              = {'f4'},
            f5              = {'f5'},
            f6              = {'f6'},
            f7              = {'f7'},
            f8              = {'f8'},
            f9              = {'f9'},
            f10             = {'f10'},
            f11             = {'f11'},
            f12             = {'f12'}
        },
        joysticks           = {
        },
        gameplay            = {
        },
        graphics            = {
            width           = 1280,
            height          = 720,
            fullscreen      = false,
            vsync           = true,
            fsaa            = 0,
            resizable       = false,
            borderless      = false,
            centered        = true
        },
        options             = {
            language        = 'en_US'
        }
    }
}

-- / ---------------------------------------------------------------------- \ --
-- | Entry point of LÖVE before modules are loaded                          | --
-- \ ---------------------------------------------------------------------- / --
function love.conf(game)
    local nexus = nexus
    local version = nexus.constants.VERSION
    local debugmode = nexus.constants.DEBUG_MODE
    local filename = nexus.constants.PATHS.CONFIGURE
    local identifier = nexus.constants.CONFIGURE_IDENTIFIER

    setmetatable(nexus, { __call = require 'bootstrap' })

    love.filesystem.setIdentity('code-nexus')
    if not nexus.core.exists(filename) then
        nexus.core.save(filename, nexus.configures, identifier)
        nexus.constants.FIRST_RUN = true
    end
    nexus.configures = nexus.core.read(filename)

    game.title = 'CODE NEXUS'
    if debugmode then
        game.title = 'CODE NEXUS ' .. '(Build ' .. version.BUILD .. ' - ' .. version.STAMP .. ')'
    end
    game.author = 'Yang Sheng Han'
    game.url = 'http://yangshenghan.twbbs.org'
    game.version = '0.8.0'
    game.release = not debugmode

    game.modules.physics = false

    game.screen.width = nexus.constants.FALLBACK_WIDTH
    game.screen.height = nexus.constants.FALLBACK_HEIGHT
    game.screen.resizable = nexus.configures.graphics.resizable
    game.screen.borderless = nexus.configures.graphics.borderless
    game.screen.centered = nexus.configures.graphics.centered

    if nexus.configures.graphics then
        game.screen.width = nexus.configures.graphics.width
        game.screen.height = nexus.configures.graphics.height
        game.screen.fullscreen = nexus.configures.graphics.fullscreen
        game.screen.vsync = nexus.configures.graphics.vsync
        game.screen.fsaa = nexus.configures.graphics.fsaa
    end
end
