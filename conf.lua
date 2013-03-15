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

-- / ---------------------------------------------------------------------- \ --
-- | Basic functions of the game                                            | --
-- \ ---------------------------------------------------------------------- / --
local serialize         = require 'src.system.serialize'
local deserialize       = require 'src.system.deserialize'
local compress          = require 'src.system.compress'
local decompress        = require 'src.system.decompress'
local dump              = require 'src.system.dump'

function table.first(t)
    return t[1]
end

function table.last(t)
    return t[table.maxn(t)]
end

function table.clone(t, metatable)
    local u = {}

    if metatable then
        setmetatable(u, metatable)
    else
        setmetatable(u, getmetatable(t))
    end

    for key, value in pairs(t) do
        if type(value) == 'table' then
            u[key] = table.clone(value)
        else
            u[key] = value
        end
    end
    return u
end

function table.merge(t, s)
    local r = table.clone(t)

    for key, value in pairs(s) do
        r[key] = value
    end

    return r
end

function table.recursiveMerge(t, s)
    for key, value in pairs(t) do
        if type(value) == 'table' then
            table.recursiveMerge(s[key], value)
        else
            s[key] = value
        end
    end
end

-- / ---------------------------------------------------------------------- \ --
-- | Construction of base nexus table                                       | --
-- \ ---------------------------------------------------------------------- / --
NEXUS_KEY = {
    Z           = 'z',
    X           = 'x',
    C           = 'c',
    V           = 'v',
    A           = 'a',
    S           = 's',
    D           = 'd',
    F           = 'f',
    UP          = 'up',
    RIGHT       = 'right',
    DOWN        = 'down',
    LEFT        = 'left',
    CONFIRM     = 'confirm',
    CANCEL      = 'cancel'
}

nexus = {
    settings    = {
        showfps     = true,
        console     = true
    },
    configures  = {
        graphics    = {
            width       = 1280,
            height      = 720,
            fullscreen  = false,
            vsync       = true,
            fsaa        = 0
        },
        audios      = {
        },
        controls    = {
            z           = {'z'},
            x           = {'x'},
            c           = {'c'},
            v           = {'v'},
            a           = {'a'},
            s           = {'s'},
            d           = {'d'},
            f           = {'f'},
            up          = {'up'},
            right       = {'right'},
            down        = {'down'},
            left        = {'left'},
            confirm     = {'return'},
            cancel      = {'escape'}
        }
    },
    system      = { -- shouldn't be changed at runtime
        version     = {
            major       = '0',
            minor       = '1',
            micro       = '0',
            patch       = '0',
            build       = '0',
            stamp       = '20130228',
            stage       = 'Development',
        },
        paths       = {
            identity    = 'code-nexus',
            configure   = 'config.dat',
            saving      = 'save-%2d.sav',
            maps        = 'data/maps/',
            texts       = 'data/texts/',
            stages      = 'data/stages/',
            scripts     = 'data/scripts/',
            objects     = 'data/objects/'
        },
        defaults    = {
            width       = 640,
            height      = 360,
            fullscreen  = false
        },
        parameters  = {
            logical_grid_size       = 16
        },
        debug       = true,
        level       = 5,
        firstrun    = false
    }
}

-- / ---------------------------------------------------------------------- \ --
-- | Utility functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
nexus.utility = {}

local m_version = nil
local t_upgrader = {}

function nexus.utility.getGameVersion()
    if not m_version then
        m_version = tonumber(nexus.system.version.major) * 2 ^ 24 + tonumber(nexus.system.version.minor) * 2 ^ 16 + tonumber(nexus.system.version.micro) * 2 ^ 8 + tonumber(nexus.system.version.patch)
    end
    return m_version
end

function nexus.utility.getVersionString()
    return nexus.system.version.major .. '.' .. nexus.system.version.minor .. '.' .. nexus.system.version.micro
end

function nexus.utility.getScreenModes()
    local modes = love.graphics.getModes()
    table.sort(modes, function(a, b) return a.width * a.height < b.width * b.height end)
    return modes
end

function nexus.utility.getBestScreenMode()
    return table.last(nexus.utility.getScreenModes())
end

function nexus.utility.upgradeGameData(identifier, chunk)
    return chunk.data
end

function nexus.utility.registerDataUpgrader(identifier, upgrader)
end

-- / ---------------------------------------------------------------------- \ --
-- | Core functions in the game                                             | --
-- \ ---------------------------------------------------------------------- / --
nexus.core = {}

local t_paths   = {
    map             = nexus.system.paths.maps,
    text            = nexus.system.paths.texts,
    stage           = nexus.system.paths.stages,
    script          = nexus.system.paths.scripts,
    object          = nexus.system.paths.objects
}

function nexus.core.serialize(data)
    return serialize(data)
end

function nexus.core.decompress(data)
    return decompress(data)
end

function nexus.core.deserialize(data)
    return deserialize(data)
end

function nexus.core.decompress(data)
    return decompress(data)
end

function nexus.core.dump(...)
    return dump(...)
end

function nexus.core.save(filename, data, identifier)
    local chunk = {
        identifier  = identifier,
        version     = nexus.utility.getGameVersion(),
        data        = data
    }
    return love.filesystem.write(filename, compress(serialize(chunk)))
end

function nexus.core.read(filename)
    local chunk = deserialize(decompress(love.filesystem.read(filename)))
    if chunk.version < nexus.utility.getGameVersion() then
        local data = nexus.utility.upgradeGameData(chunk.identifier, chunk) 
        nexus.core.save(filename, data, chunk.identifier)
    elseif chunk.version > nexus.utility.getGameVersion() then
        return nil
    end
    return chunk.data
end

function nexus.core.load(identifier, filename)
    local ok
    local chunk
    local result
    local path = t_paths[identifier] .. filename .. '.lua'

    ok, chunk = pcall(love.filesystem.load, path)
    if not ok then
        error('The following error happend: ' .. tostring(chunk))
    else
        ok, result = pcall(chunk)
        if not ok then
            error('The following error happened: ' .. tostring(result))
        end
    end

    return result
end

-- / ---------------------------------------------------------------------- \ --
-- | Entry point of LÖVE before modules are loaded                          | --
-- \ ---------------------------------------------------------------------- / --
function love.conf(game)
    local identity = nexus.system.paths.identity
    local filename = nexus.system.paths.configure

    love.filesystem.setIdentity(identity)
    if not love.filesystem.exists(filename) then
        nexus.core.save(filename, nexus.configures)
        nexus.system.firstrun = true
    end
    nexus.configures = nexus.core.read(filename)

    game.title = 'CODE NEXUS'
    if nexus.system.debug then
        game.title = 'CODE NEXUS ' .. nexus.system.version.stage .. ' (Build ' .. nexus.system.version.build .. ' - ' .. nexus.system.version.stamp .. ')'
    end
    game.author = 'Yang Sheng Han'
    game.url = 'http://yangshenghan.twbbs.org'
    game.identity = identity
    game.release = not nexus.system.debug

    game.modules.physics = false

    game.screen.width = nexus.system.defaults.width
    game.screen.height = nexus.system.defaults.height
    game.screen.fullscreen = nexus.system.defaults.fullscreen
 
    if nexus.configures then
        game.screen.width = nexus.configures.graphics.width
        game.screen.height = nexus.configures.graphics.height
        game.screen.fullscreen = nexus.configures.graphics.fullscreen
        game.screen.vsync = nexus.configures.graphics.vsync
        game.screen.fsaa = nexus.configures.graphics.fsaa
    end
end
