--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-12                                                    ]]--
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

local m_caption = love.graphics.getCaption()

function love.load(args)
    -- Load some resources
    -- local icon = nexus.manager.resource.loadImage('icon.png')
    local font = nexus.manager.resource.loadFont('inconsolata.otf', 16)

    -- Initialize LÖVE subsystems
    love.graphics.setBackgroundColor(0, 0, 0)
    -- love.graphics.setIcon(icon)
    -- love.mouse.setGrab(true)
    love.mouse.setVisible(false)
    love.physics.setMeter(32)

    -- Initialize game subsystem
    nexus.input.initialize()
    -- nexus.console.initialize(font)

    -- Initialize game managers
    nexus.manager.resource.initialize()
    nexus.manager.screen.initialize()
    nexus.manager.object.initialize()

    -- Initialize game instance actually
    nexus.game.initialize()
end

function love.update(dt)
    if nexus.settings.showfps then
        local fps = love.timer.getFPS()
        love.graphics.setCaption(m_caption .. ' - FPS: ' .. fps)
    end

    nexus.input.update()
    nexus.manager.screen.update(dt)
end

function love.draw()
    nexus.manager.screen.draw()

    -- if nexus.settings.console then
        -- local color = {love.graphics.getColor()}
        -- love.graphics.setColor(34, 34, 34, 180)
        -- love.graphics.rectangle('fill', 2, 2, love.graphics.getWidth() - 4, love.graphics.getHeight() - 4)
        -- love.graphics.setColor(240, 240, 0, 255)
        -- nexus.console.draw(4, love.graphics.getHeight() - 4)
        -- love.graphics.setColor(unpack(color))
    -- end
end

function love.focus(focus)
    if focus then
        -- Resume audio system
    else
        -- Pause audio system
    end
end

function love.keypressed(key, unicode)
    if key == 'f1' then
        nexus.settings.showfps = not nexus.settings.showfps
        if not nexus.settings.showfps then
            love.graphics.setCaption(m_caption)
        end
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

function love.quit()
end
