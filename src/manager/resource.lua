nexus.manager.resource = {
    fonts   = {}
}

function nexus.manager.resource.initialize()
end

function nexus.manager.resource.getAudioPath()
    return 'res/audios/'
end

function nexus.manager.resource.getFontPath()
    return 'res/fonts/'
end

function nexus.manager.resource.getGraphicsPath()
    return 'res/graphics/'
end

function nexus.manager.resource.getSoundPath()
    return 'res/sounds/'
end

function nexus.manager.resource.getVideoPath()
    return 'res/videos/'
end

function nexus.manager.resource.getMapPath()
    return 'data/maps/'
end

function nexus.manager.resource.loadFont(filename, size)
    local filename = nexus.manager.resource.getFontPath() .. filename

    if nexus.manager.resource.fonts[filename] == nil then
        nexus.manager.resource.fonts[filename] = {}
    end
    if nexus.manager.resource.fonts[filename][size] == nil then
        nexus.manager.resource.fonts[filename][size] = love.graphics.newFont(filename, size)
    end
    return nexus.manager.resource.fonts[filename][size]
end
