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
local l                     = love
local la                    = l.audio
local lg                    = l.graphics

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Resource              = {}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local t_fonts               = {}

local t_images              = {}

local t_sources             = {}

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function load_font_resource(folder, filename, size)
    local path = folder .. filename

    if not t_fonts[path] then
        t_fonts[path] = {}
    end

    if not t_fonts[path][size] then
        t_fonts[path][size] = lg.newFont(path, size)
    end

    return t_fonts[path][size]
end

local function load_image_resource(folder, filename)
    local path = folder .. filename

    if not t_images[path] then
        t_images[path] = lg.newImage(path)
    end

    return t_images[path]
end

local function load_source_resource(folder, filename)
    local path = folder .. filename

    if not t_sources[path] then
        t_sources[path] = la.newSource(path)
    end

    return t_sources[path]
end

-- / ---------------------------------------------------------------------- \ --
-- | Member functions                                                       | --
-- \ ---------------------------------------------------------------------- / --
function Resource.initialize()
end

function Resource.finalize()
    Resource.reset()
end

function Resource.reset()
    t_fonts = {}
    t_images = {}
    t_sources = {}
    collectgarbage()
end

function Resource.loadEffectSource(filename)
    return load_source_resource('res/audios/effects/', filename)
end

function Resource.loadMusicSource(filename)
    return load_source_resource('res/audios/musics/', filename)
end

function Resource.loadSoundSource(filename)
    return load_source_resource('res/audios/sounds/', filename)
end

function Resource.loadAnimationIamge(filename)
    return load_image_resource('res/graphics/animations/', filename)
end

function Resource.loadCharacterImage(filename)
    return load_image_resource('res/graphics/characters/', filename)
end

function Resource.loadIconImage(filename)
    return load_image_resource('res/graphics/icons/', filename)
end

function Resource.loadMapImage(filename)
    return load_image_resource('res/graphics/maps/', filename)
end

function Resource.loadObjectImage(filename)
    return load_image_resource('res/graphics/objects/', filename)
end

function Resource.loadPictureImage(filename)
    return load_image_resource('res/graphics/pictures/', filename)
end

function Resource.loadSystemImage(filename)
    return load_image_resource('res/graphics/systems/', filename)
end

function Resource.loadFontData(filename, size)
    return load_font_resource('res/fonts/', filename, size)
end

return Resource
