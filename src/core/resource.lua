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
local string                = string
local collectgarbage        = collectgarbage
local l                     = love
local la                    = l.audio
local lg                    = l.graphics
local lf                    = l.filesystem
local Nexus                 = nexus
local Core                  = Nexus.core
local Configures            = Nexus.configures
local OptionConfigures      = Configures.options

-- / ---------------------------------------------------------------------- \ --
-- | Declare object                                                         | --
-- \ ---------------------------------------------------------------------- / --
local Resource              = {
    SOURCE_TYPE_STATIC      = 'static',
    SOURCE_TYPE_STREAM      = 'stream'
}

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local t_fonts               = {}

local t_glyphs              = {}

local t_images              = {}

local t_videos              = {}

local t_sources             = {}

local FONT_EXTENSIONS       = { 'ttf', 'ttc', 'otf', 'otc', 'pfa', 'pfb', 'cid', 'cff', 'bdf', 'pfr' }

local GLYPH_EXTENSIONS      = { 'png', 'jpg', 'bmp' }

local IMAGE_EXTENSIONS      = { 'png', 'mng', 'jpg', 'bmp', 'tiff', 'tga', 'ico', 'cur', 'psd', 'raw' }

local VIDEO_EXTENSIONS      = { 'cvd' }

local SOURCE_EXTENSIONS     = { 'ogg', 'mp3', 'wav' }

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function get_localization_filename(folder, filename, extensions)
    local path = nil
    if string.find(filename, '.+%..+') then
        path = string.format('%s/%s/%s', folder, OptionConfigures.language, filename)
        if lf.exists(path) then return path end

        path = string.format('%s/%s', folder, filename)
        if lf.exists(path) then return path end
    else
        for _, extension in ipairs(extensions) do
            path = string.format('%s/%s/%s.%s', folder, OptionConfigures.language, filename, extension)
            if lf.exists(path) then return path end

            path = string.format('%s/%s.%s', folder, filename, extension)
            if lf.exists(path) then return path end
        end
    end
    return nil
end

local function load_font_resource(folder, filename, size)
    local path = get_localization_filename(folder, filename, FONT_EXTENSIONS)

    if not t_fonts[path] then t_fonts[path] = {} end

    if not t_fonts[path][size] then t_fonts[path][size] = lg.newFont(path, size) end

    return t_fonts[path][size]
end

local function load_glyph_resource(folder, filename, glyphs)
    local path = get_localization_filename(folder, filename, GLYPH_EXTENSIONS)

    if not t_glyphs[path] then t_glyphs[path] = lg.newImageFont(path, glyphs) end

    return t_glyphs[path]
end

local function load_image_resource(folder, filename)
    local path = get_localization_filename(folder, filename, IMAGE_EXTENSIONS)

    if not t_images[path] then t_images[path] = lg.newImage(path) end

    return t_images[path]
end

local function load_source_resource(folder, filename, type)
    local path = get_localization_filename(folder, filename, SOURCE_EXTENSIONS)

    if not t_sources[path] then t_sources[path] = la.newSource(path, type) end

    return t_sources[path]
end

local function load_video_resource(folder, filename)
    local path = get_localization_filename(folder, filename, VIDEO_EXTENSIONS)

    if not t_videos[path] then t_videos[path] = nil end

    return t_videos[path]
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
    t_glyphs = {}
    t_images = {}
    t_videos = {}
    t_sources = {}
    collectgarbage()
end

function Resource.loadEffectSource(filename, type)
    return load_source_resource('res/audios/effects', filename, type or Resource.SOURCE_TYPE_STATIC)
end

function Resource.loadMusicSource(filename, type)
    return load_source_resource('res/audios/musics', filename, type or Resource.SOURCE_TYPE_STREAM)
end

function Resource.loadSoundSource(filename, type)
    return load_source_resource('res/audios/sounds', filename, type or Resource.SOURCE_TYPE_STATIC)
end

function Resource.loadAnimationIamge(filename)
    return load_image_resource('res/graphics/animations', filename)
end

function Resource.loadCharacterImage(filename)
    return load_image_resource('res/graphics/characters', filename)
end

function Resource.loadIconImage(filename)
    return load_image_resource('res/graphics/icons', filename)
end

function Resource.loadMapImage(filename)
    return load_image_resource('res/graphics/maps', filename)
end

function Resource.loadObjectImage(filename)
    return load_image_resource('res/graphics/objects', filename)
end

function Resource.loadPictureImage(filename)
    return load_image_resource('res/graphics/pictures', filename)
end

function Resource.loadSystemImage(filename)
    return load_image_resource('res/graphics/systems', filename)
end

function Resource.loadFontData(filename, size)
    return load_font_resource('res/fonts', filename, size)
end

function Resource.loadGlyphData(filename, glyphs)
    return load_glyph_resource('res/glyphs', filename, glyphs)
end

function Resource.loadVideoData(filename)
    return load_video_resource('res/videos', filename)
end

return Resource
