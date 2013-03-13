--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-13                                                    ]]--
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
require 'bootstrap'

love.load = nexus.game.initialize
love.quit = nexus.game.finalizer
love.draw = nexus.game.render
love.focus = nexus.game.focus
love.update = nexus.game.update

function love.keypressed(key, unicode)
    if key == 'f1' then
        nexus.game.toggleFPS()
    end

    if key == 'f4' then
        nexus.settings.console = not nexus.settings.console
    end

    if (love.keyboard.isDown('lalt') or love.keyboard.isDown('ralt')) and key == 'return' then
        nexus.game.toggleFullscreen()
    end

    -- if nexus.settings.console then
        -- return nexus.console.keypressed(key, unicode)
    -- end

    -- if key == 'rctrl' then
        -- debug.debug()
        -- nexus.game.debug = true
    -- end

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyreleased(key, unicode)
    -- if key == 'rctrl' then
        -- nexus.game.debug = false
    -- end
end
