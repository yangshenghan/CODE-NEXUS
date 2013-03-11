--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-02-28                                                    ]]--
--[[ License: ?                                                             ]]--
--[[                                                                        ]]--
--[[                                                                        ]]--
--[[ ********************************************************************** ]]--

-- / ---------------------------------------------------------------------- \ --
-- | Basic functions of the game                                            | --
-- \ ---------------------------------------------------------------------- / --
local serialize         = require 'src/system/serialize'
local deserialize       = require 'src/system/deserialize'
local compress          = require 'src/system/compress'
local decompress        = require 'src/system/decompress'
local dump              = require 'src/system/dump'

function table.first(t)
    return t[1]
end

function table.last(t)
    return t[table.maxn(t)]
end

-- / ---------------------------------------------------------------------- \ --
-- | Construction of base nexus table                                       | --
-- \ ---------------------------------------------------------------------- / --
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
            vsync       = false,
            fsaa        = 0
        },
        audios      = {
        },
        controls    = {
            rush        = {'z'},
            jump        = {'x'},
            attack      = {'c'},
            squat       = {'down'},
            up          = {'up'},
            right       = {'right'},
            down        = {'down'},
            left        = {'left'},
            menu        = {'escape', 'return'}
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
            saving      = 'save-%d.sav',
            objects     = 'data/objects/',
            stages      = 'data/stages/'
        },
        defaults    = {
            width       = 640,
            height      = 360,
            fullscreen  = false
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
    stage           = nexus.system.paths.stages,
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
