--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-17                                                    ]]--
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

nexus.scene = {}
nexus.object = {}
nexus.window = {}

local m_loaded = false

local function adjust_screen_mode()
    local best_screen_mode = nexus.graphics.getBestScreenMode()

    local ow = nexus.configures.graphics.width
    local oh = nexus.configures.graphics.height
    local bw = best_screen_mode.width
    local bh = best_screen_mode.height

    if ow > bw or oh > bh or ow * oh > bw * bh then
        if bw > bh then
            nexus.graphics.changeGraphicsConfigures(bw, bw * 9 / 16, fullscreen)
        else
            nexus.graphics.changeGraphicsConfigures(bh * 16 / 9, bh, fullscreen)
        end
    end
end

function nexus.game.initialize()
    nexus.audio.initialize()
    nexus.database.initialize()
    nexus.graphics.initialize()
    nexus.input.initialize()
    nexus.message.initialize()
    nexus.resource.initialize()
    nexus.scene.initialize()

    nexus.game.data = nil

    if nexus.configures and not nexus.system.error then
        if nexus.system.firstrun then
            adjust_screen_mode()
        end
        nexus.scene.goto(nexus.scene.title.new(m_loaded))
        -- nexus.scene.goto(nexus.scene.stage.new('prologue'))
        if nexus.settings.console then
            nexus.scene.enter(nexus.scene.console.new())
        end
        m_loaded = true
    else
        nexus.scene.goto(nexus.scene.error.new(nexus.database.getTranslatedText('Your game version is older than saving data!')))
    end
end

function nexus.game.update(dt)
    nexus.audio.update(dt)
    nexus.graphics.update(dt)
    nexus.input.update(dt)
    nexus.message.update(dt)
    nexus.scene.update(dt)
end

function nexus.game.render()
    nexus.graphics.render()
    nexus.message.render()
    nexus.scene.render()
end

function nexus.game.reload()
    nexus.game.finalize()
    love.event.clear()
    nexus.game.initialize()
end

function nexus.game.finalize()
    nexus.scene.finalize()
    nexus.resource.finalize()
    nexus.message.finalize()
    nexus.input.finalize()
    nexus.graphics.finalize()
    nexus.database.finalize()
    nexus.audio.finalize()
end

function nexus.game.focus(focus)
    if focus then
        nexus.scene.resume()
        nexus.message.resume()
        nexus.input.resume()
        nexus.graphics.resume()
        nexus.audio.resume()
    else
        nexus.audio.pause()
        nexus.graphics.pause()
        nexus.input.pause()
        nexus.message.pause()
        nexus.scene.pause()
    end
end

function nexus.game.exit()
    love.event.quit()
end

function nexus.game.changeGameplayConfigures()
    nexus.game.saveGameConfigure()
end

function nexus.game.saveGameConfigure()
    nexus.core.save(nexus.system.paths.configure, nexus.configures, 'configure')
end
