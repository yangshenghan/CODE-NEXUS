--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS] Game building script                                      ]]--
--[[ This script is for simplifying the process of building CODE NEXUS in   ]]--
--[[ release mode. It also compress and optimistize resources and data.     ]]--
--[[ Then pack all the data in an executable file.                          ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-12                                                    ]]--
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
local chunks = {}

local files = {
    '../../data/stages/prologue.lua'
}

local output = assert(io.open('compiled.lua', 'wb'))

for _, file in ipairs(files) do
    chunks[#chunks + 1] = assert(loadfile(file))
end

if #chunks == 1 then
    chunks = chunks[1]
else
    for i, f in ipairs(chunks) do
        chunks[i] = string.format('%sloadstring%q(...);', i == #chunks and 'return ' or ' ', string.dump(f))
    end
    chunks = assert(loadstring(table.concat(chunks)))
end

output.write(output, string.dump(chunks))
output.close(output)