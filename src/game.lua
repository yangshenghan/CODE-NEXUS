nexus.game = {}

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

function nexus.game.initialize()
    if nexus.configures then
        if nexus.system.firstrun then
            adjust_screen_mode()
        end
        nexus.game.changeScreen(nexus.screen.title.new())
        -- nexus.game.changeScreen(nexus.screen.stage.new('prologue'))
    else
        nexus.game.changeScreen(nexus.screen.error.new('Your game version is older than saving data!'))
    end
end

function nexus.game.toggleFullscreen()
    love.graphics.toggleFullscreen()
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

function nexus.game.changeScreen(screen)
    return nexus.manager.screen.change(screen)
end

function nexus.game.enterScreen(screen)
    return nexus.manager.screen.push(screen)
end

function nexus.game.leaveScreen()
    return nexus.manager.screen.pop()
end
