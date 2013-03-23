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

-- / ---------------------------------------------------------------------- \ --
-- | Import modules                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Nexus     = nexus
local NexusCore = Nexus.core

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
NexusCore.data  = {}

local Data      = NexusCore.data

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local t_fonts = {}

local t_texts = {}

local t_caches = {}

local t_colors = {}

local t_formats = {}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function load_data_resource(folder, filename)
    local path = folder .. filename .. '.lua'

    if not t_caches[path] then
        t_caches[path] = nexus.core.load(path)
    end

    return t_caches[path]
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Data.initialize()
    t_colors = Data.loadDatabaseData('colors')
end

function Data.finalize()
    Data.reset()
end

function Data.reset()
    t_formats = {}
    t_colors = {}
    t_caches = {}
    t_texts = {}
    t_fonts = {}
end

function Data.loadDatabaseData(filename)
    return load_data_resource('data/databases/', filename)
end

function Data.loadExtraData(filename)
    return load_data_resource('data/extras/', filename)
end

function Data.loadMapData(filename)
    return load_data_resource('data/maps/', filename)
end

function Data.loadObjectData(filename)
    return load_data_resource('data/objects/', filename)
end

function Data.loadScriptData(filename)
    return load_data_resource('data/scripts/', filename)
end

function Data.loadStageData(filename)
    return load_data_resource('data/stages/', filename)
end

function Data.loadTextData(filename)
    local texts = load_data_resource('data/texts/', filename)
    t_fonts = texts.fonts
    t_texts = texts.texts
    t_formats = texts.formats
    return texts
end

function Data.getTranslationList()
end

function Data.getTranslatedText(text)
    return t_texts[text] or text
end

function Data.getColor(index)
    local color = t_colors[index]
    if color then return nexus.base.color.get(color) end
    return 0, 0, 0, 0
end

-- function Data.changeOptionConfigures()
    -- Game.saveGameConfigure()
-- end

return Data