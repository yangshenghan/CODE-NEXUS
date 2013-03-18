--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-18                                                    ]]--
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

nexus.core.database = {
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
    return load_data_resource('data/texts/', filename)
end

function nexus.core.database.getTextsList()
    
end

function nexus.core.database.getTranslatedText(text)
    return nexus.core.database.texts[text] or text
end

function nexus.core.database.initialize()
    local texts = nexus.core.database.loadTextData(nexus.configures.options.language)

    nexus.core.database.fonts = texts.fonts
    nexus.core.database.texts = texts.texts
    nexus.core.database.formats = texts.formats
end

function nexus.core.database.finalize()
    nexus.core.database.formats = {}
    nexus.core.database.texts = {}
    nexus.core.database.fonts = {}

    nexus.core.database.clear()
end

function nexus.core.database.clear()
    t_caches = {}
end

function nexus.core.database.changeOptionConfigures()
    nexus.game.saveGameConfigure()
end
