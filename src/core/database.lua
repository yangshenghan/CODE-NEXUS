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
local nexus = nexus

nexus.core.database = {
    fonts       = {},
    texts       = {},
    colors      = {},
    formats     = {}
}

local t_caches = {}

local t_colors = {}

local function load_data_resource(folder, filename)
    local path = folder .. filename .. '.lua'

    if not t_caches[path] then
        t_caches[path] = nexus.core.load(path)
    end

    return t_caches[path]
end

function nexus.core.database.loadDatabaseData(filename)
    return load_data_resource('data/databases/', filename)
end

function nexus.core.database.loadExtraData(filename)
    return load_data_resource('data/extras/', filename)
end

function nexus.core.database.loadMapData(filename)
    return load_data_resource('data/maps/', filename)
end

function nexus.core.database.loadObjectData(filename)
    return load_data_resource('data/objects/', filename)
end

function nexus.core.database.loadScriptData(filename)
    return load_data_resource('data/scripts/', filename)
end

function nexus.core.database.loadStageData(filename)
    return load_data_resource('data/stages/', filename)
end

function nexus.core.database.loadTextData(filename)
    local texts = load_data_resource('data/texts/', filename)
    nexus.core.database.fonts = texts.fonts
    nexus.core.database.texts = texts.texts
    nexus.core.database.formats = texts.formats
    return texts
end

function nexus.core.database.getTextsList()
    
end

function nexus.core.database.getTranslatedText(text)
    return nexus.core.database.texts[text] or text
end

function nexus.core.database.setTranslationTexts(language)
end

function nexus.core.database.initialize(databases)
    for index, filename in pairs(databases) do
        if nexus.core.database[index] then
            nexus.core.database[index] = nexus.core.database.loadDatabaseData(filename)
        end
    end
end

function nexus.core.database.finalize()
    nexus.core.database.formats = {}
    nexus.core.database.colors = {}
    nexus.core.database.texts = {}
    nexus.core.database.fonts = {}

    nexus.core.database.reset()
end

function nexus.core.database.reset()
    t_caches = {}
end

function nexus.core.database.getColor(index)
    local color = nexus.core.database.colors[index]
    if color then return nexus.base.color.get(color) end
    return 0, 0, 0, 0
end

function nexus.core.database.changeOptionConfigures()
    nexus.game.saveGameConfigure()
end
