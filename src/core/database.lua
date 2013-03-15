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
nexus.database = {
    fonts       = {},
    texts       = {},
    formats     = {}
}

local t_caches = {}

local function load_data_resource(folder, filename)
    local path = folder .. filename .. '.lua'

    if not t_caches[path] then
        t_caches[path] = nexus.core.load(path)
    end

    return t_caches[path]
end

function nexus.database.loadMapData(filename)
    return load_data_resource('data/maps/', filename)
end

function nexus.database.loadObjectData(filename)
    return load_data_resource('data/objects/', filename)
end

function nexus.database.loadScriptData(filename)
    return load_data_resource('data/scripts/', filename)
end

function nexus.database.loadStageData(filename)
    return load_data_resource('data/stages/', filename)
end

function nexus.database.loadTextData(filename)
    return load_data_resource('data/texts/', filename)
end

function nexus.database.getTextsList()
    
end

function nexus.database.getTranslatedText(text)
    return nexus.database.texts[text] or text
end

function nexus.database.initialize()
    local texts = nexus.database.loadTextData(nexus.configures.options.language)

    nexus.database.fonts = texts.fonts
    nexus.database.texts = texts.texts
    nexus.database.formats = texts.formats
end

function nexus.database.finalize()
    nexus.database.formats = {}
    nexus.database.texts = {}
    nexus.database.fonts = {}

    nexus.database.clear()
end

function nexus.database.update(dt)
end

function nexus.database.clear()
    t_caches = {}
end

function nexus.database.changeOptionConfigures()
    nexus.game.saveGameConfigure()
end
