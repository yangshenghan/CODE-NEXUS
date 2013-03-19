--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-19                                                    ]]--
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
local nexus = nexus

nexus.game = {}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_loaded = false

local function adjust_screen_mode()
    local best_screen_mode = nexus.core.graphics.getBestScreenMode()

    local ow = nexus.graphics.getScreenWidth()
    local oh = nexus.graphics.getScreenHeight()
    local bw = best_screen_mode.width
    local bh = best_screen_mode.height

    if ow > bw or oh > bh or ow * oh > bw * bh then
        if bw > bh then
            nexus.core.graphics.changeGraphicsConfigures(bw, bw * 9 / 16, fullscreen)
        else
            nexus.core.graphics.changeGraphicsConfigures(bh * 16 / 9, bh, fullscreen)
        end
    end
end

function nexus.game.initialize()
    nexus.core.audio.initialize()
    nexus.core.database.initialize()
    nexus.core.graphics.initialize()
    nexus.core.input.initialize()
    nexus.core.message.initialize()
    nexus.core.resource.initialize()
    nexus.core.scene.initialize()

    nexus.game.data = nil

    if nexus.configures and not nexus.system.error and love.graphics.isSupported('canvas') then
        if nexus.system.firstrun then
            adjust_screen_mode()
        end
        nexus.core.scene.goto(nexus.scene.title.new(m_loaded))
        -- nexus.core.scene.goto(nexus.scene.stage.new('prologue'))
        if nexus.settings.console then
            nexus.core.scene.enter(nexus.scene.console.new())
        end
        m_loaded = true
    else
        nexus.core.scene.goto(nexus.scene.error.new(nexus.core.database.getTranslatedText('Your game version is older than saving data!')))
    end
end

function nexus.game.update(dt)
    nexus.core.audio.update(dt)
    nexus.core.graphics.update(dt)
    nexus.core.input.update(dt)
    nexus.core.message.update(dt)
    nexus.core.scene.update(dt)
end

function nexus.game.render()
    nexus.core.graphics.render()
    nexus.core.message.render()
    nexus.core.scene.render()
end

function nexus.game.reload()
    nexus.game.finalize()
    love.event.clear()
    nexus.game.initialize()
end

function nexus.game.finalize()
    nexus.core.scene.finalize()
    nexus.core.resource.finalize()
    nexus.core.message.finalize()
    nexus.core.input.finalize()
    nexus.core.graphics.finalize()
    nexus.core.database.finalize()
    nexus.core.audio.finalize()
end

function nexus.game.focus(focus)
    if focus then
        nexus.core.scene.resume()
        nexus.core.message.resume()
        nexus.core.input.resume()
        nexus.core.graphics.resume()
        nexus.core.audio.resume()
    else
        nexus.core.audio.pause()
        nexus.core.graphics.pause()
        nexus.core.input.pause()
        nexus.core.message.pause()
        nexus.core.scene.pause()
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
