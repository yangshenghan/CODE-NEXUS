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
