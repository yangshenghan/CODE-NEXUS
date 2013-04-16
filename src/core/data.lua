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
local pairs                 = pairs
local ipairs                = ipairs
local string                = string
local collectgarbage        = collectgarbage
local l                     = love
local lf                    = l.filesystem
local Nexus                 = nexus
local Core                  = Nexus.core
local Resource              = Core.import 'nexus.core.resource'
local Color                 = Core.import 'nexus.base.color'
local Font                  = Core.import 'nexus.base.font'

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Data                  = {}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local t_fonts               = {}

local t_terms               = {}

local t_texts               = {}

local t_caches              = {}

local t_colors              = {}

local t_systems             = {}

local t_formats             = {}

local t_localizations       = {}

local t_languages           = {}

local t_pixel_shaders       = {}

local t_vertex_shaders      = {}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function load_data_resource(folder, filename)
    local path = string.format('%s/%s.lua', folder, filename)
    if not t_caches[path] then t_caches[path] = lf.load(path) end
    return t_caches[path]
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Data.initialize()
    t_colors = Data.loadDatabaseData('colors')
    t_systems = Data.loadDatabaseData('systems')
    t_languages = Data.loadDatabaseData('languages')
    t_pixel_shaders = Data.loadDatabaseData('pixelshaders')
    t_vertex_shaders = Data.loadDatabaseData('vertexshaders')
end

function Data.finalize()
    Data.reset()
end

function Data.reset()
    t_vertex_shaders = {}
    t_pixel_shaders = {}
    t_localizations = {}
    t_formats = {}
    t_systems = {}
    t_colors = {}
    t_caches = {}
    t_texts = {}
    t_terms = {}
    t_fonts = {}
    collectgarbage()
end

function Data.loadDatabaseData(filename)
    return load_data_resource('data/databases', filename)
end

function Data.loadExtraData(filename)
    return load_data_resource('data/extras', filename)
end

function Data.loadMapData(filename)
    return load_data_resource('data/maps', filename)
end

function Data.loadObjectData(filename)
    return load_data_resource('data/objects', filename)
end

function Data.loadScriptData(filename)
    return load_data_resource('data/scripts', filename)
end

function Data.loadStageData(filename)
    return load_data_resource('data/stages/', filename)
end

function Data.loadLanguageData(filename)
    local language = load_data_resource('data/languages', filename)
    for index, font in ipairs(language.fonts.name) do
        t_fonts[font] = Font.new(language.fonts.file[index], language.fonts.size[index])
    end
    t_terms = language.terms
    t_texts = language.texts
    t_formats = language.formats
    t_localizations = language.localizations
    return language
end

function Data.getLanguageList()
    return t_languages
end

function Data.getFont(font)
    return t_fonts[font]
end

function Data.getTerm(term)
    return t_terms[term]
end

function Data.getText(text)
    return t_texts[text] or text
end

function Data.getFormat(format, ...)
    local format = t_formats[format] or format
    if ... then
        local replacements = ...
        if type(...) ~= 'table' then replacements = {...} end
        format = string.gsub(format, '%%(%u-)%%', replacements)
        for _, value in ipairs(replacements) do format = string.gsub(format, '%%(%u-)%%', value) end
    end
    return format
end

function Data.getLocalization(key)
    return t_localizations[key]
end

function Data.getColor(index)
    local color = t_colors[index]
    if color then return Color.get(color) end
    return 0, 0, 0, 0
end

function Data.getSystem(key)
    return t_systems[key]
end

function Data.getShader(index)
    local vertex, pixel = t_vertex_shaders[index], t_pixel_shaders[index]
    if vertex or pixel then return vertex, pixel end
    return nil, nil
end

return Data
