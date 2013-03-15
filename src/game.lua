--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-15                                                    ]]--
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
nexus.game = {}

local m_caption = love.graphics.getCaption()

local t_args = nil

local t_current = nil

local t_scenes = {}

local function adjust_screen_mode()
    local best_screen_mode = table.last(nexus.utility.getScreenModes())

    local ow = nexus.configures.graphics.width
    local oh = nexus.configures.graphics.height
    local bw = best_screen_mode.width
    local bh = best_screen_mode.height

    if ow > bw or oh > bh or ow * oh > bw * bh then
        if bw > bh then
            nexus.game.changeScreenMode(bw, bw * 9 / 16, fullscreen)
        else
            nexus.game.changeScreenMode(bh * 16 / 9, bh, fullscreen)
        end
    end
end

function nexus.game.initialize(args)
    -- local icon = nexus.resource.loadImage('icon.png')
    local font = nexus.resource.loadFont('inconsolata.otf', 16)

    t_args = args

    -- Initialize LÖVE subsystems
    love.graphics.setBackgroundColor(0, 0, 0)
    -- love.graphics.setIcon(icon)
    -- love.mouse.setGrab(true)
    love.mouse.setVisible(false)
    love.physics.setMeter(32)

    -- Initialize game subsystem
    nexus.input.initialize()
    -- nexus.console.initialize(font)
    nexus.resource.initialize()

    if nexus.configures then
        if nexus.system.firstrun then
            adjust_screen_mode()
        end
        nexus.game.changeScene(nexus.scene.title.new())
        -- nexus.game.changeScene(nexus.scene.stage.new('prologue'))
    else
        nexus.game.changeScene(nexus.scene.error.new('Your game version is older than saving data!'))
    end
end

function nexus.game.update(dt)
    if nexus.settings.showfps then
        local fps = love.timer.getFPS()
        love.graphics.setCaption(m_caption .. ' - FPS: ' .. fps)
    end

    nexus.input.update()

    if t_current then
        t_current.update(t_current, dt)
    end

    for _, scene in ipairs(t_scenes) do
        if not scene.idle then
            scene.update(scene, dt)
        end
    end
end

function nexus.game.render()
    if t_current then
        t_current.render(t_current)
    end

    for _, scene in ipairs(t_scenes) do
        scene.render(scene)
    end

    -- if nexus.settings.console then
        -- local color = {love.graphics.getColor()}
        -- love.graphics.setColor(34, 34, 34, 180)
        -- love.graphics.rectangle('fill', 2, 2, love.graphics.getWidth() - 4, love.graphics.getHeight() - 4)
        -- love.graphics.setColor(240, 240, 0, 255)
        -- nexus.console.draw(4, love.graphics.getHeight() - 4)
        -- love.graphics.setColor(unpack(color))
    -- end
end

function nexus.game.reload()
    t_scenes = {}
    t_current = nil

    nexus.game.initialize(t_args)
end

function nexus.game.finalizer()
    love.audio.stop()
end

function nexus.game.focus(focus)
    if focus then
        -- Resume audio system
    else
        -- Pause audio system
    end
end

function nexus.game.toggleFullscreen()
    love.graphics.toggleFullscreen()
end

function nexus.game.toggleFPS()
    nexus.settings.showfps = not nexus.settings.showfps
    if not nexus.settings.showfps then
        love.graphics.setCaption(m_caption)
    end
end

function nexus.game.changeScreenMode(width, height, fullscreen, vsync, fsaa)
    width = width or nexus.configures.graphics.width
    height = height or nexus.configures.graphics.height
    fullscreen = fullscreen or nexus.configures.graphics.fullscreen
    vsync = vsync or nexus.configures.graphics.vsync
    fsaa = fsaa or nexus.configures.graphics.fsaa

    love.graphics.setMode(width, height, fullscreen, vsync, fsaa)

    nexus.configures.graphics.width = width
    nexus.configures.graphics.height = height
    nexus.configures.graphics.fillscreen = fullscreen
    nexus.configures.graphics.vsync = vsync
    nexus.configures.graphics.fsaa = fsaa

    nexus.core.save(nexus.system.paths.configure, nexus.configures)
end

function nexus.game.changeScene(scene)
    if t_current then
        t_current.leave(t_current)
    end
    t_current = scene
    if t_current then
        t_current.enter(t_current)
    end
end

function nexus.game.enterScene(scene)
    if #t_scenes > 0 then
        local last = table.last(t_scenes)
        nexus.scene.setIdle(last, true)
        last.idleIn(last)
    elseif t_current then
        nexus.scene.setIdle(t_current, true)
        t_current.idleIn(t_current)
    end

    table.insert(t_scenes, scene)
    scene.enter(scene)
end

function nexus.game.leaveScene()
    if #t_scenes == 0 then
        return
    end

    local popped = table.remove(t_scenes)
    popped.leave(popped)

    if #t_scenes > 0 then
        local last = table.last(t_scenes)
        nexus.scene.setIdle(last, false)
        last.idleOut(last)
    elseif t_current then
        nexus.scene.setIdle(t_current, false)
        t_current.idleOut(t_current)
    end
end

