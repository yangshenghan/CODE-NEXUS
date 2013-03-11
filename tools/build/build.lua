--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS] Game building script                                      ]]--
--[[ This script is for simplifying the process of building CODE NEXUS in   ]]--
--[[ release mode. It also compress and optimistize resources and data.     ]]--
--[[ Then pack all the data in an executable file.                          ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-08                                                    ]]--
--[[ License: ?                                                             ]]--
--[[ ********************************************************************** ]]--

-- / ---------------------------------------------------------------------- \ --
-- | Basic functions                                                        | --
-- \ ---------------------------------------------------------------------- / --
local serialize         = loadfile '../../src/system/serialize.lua'
local deserialize       = loadfile '../../src/system/deserialize.lua'
local compress          = loadfile '../../src/system/compress.lua'
local decompress        = loadfile '../../src/system/decompress.lua'

-- / ---------------------------------------------------------------------- \ --
-- | Pre-check requirements                                                 | --
-- \ ---------------------------------------------------------------------- / --
local platform          = 'Windows'
-- local platform          = 'MacOSX'
-- local platform          = 'Linux'

-- / ---------------------------------------------------------------------- \ --
-- | Actually processing the game package                                   | --
-- \ ---------------------------------------------------------------------- / --