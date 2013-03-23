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
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local f_table_concat        = table.concat
local f_string_sub          = string.sub
local f_string_byte         = string.byte
local f_string_char         = string.char

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function bytes_to_number(bytes)
    local power = 1
    local number = 0
    for index = 1, #bytes do
        number = number + f_string_byte(bytes, index, index) * power
        power = power * 256
    end
    return number
end

return function(data)
    local a = nil
    local index = 3
    local output = nil
    local output_size = 2
    local dictionary = {}
    local dictionary_size = 256

    for index = 0, 255 do
        dictionary[index] = f_string_char(index)
    end
    a = dictionary[bytes_to_number(f_string_sub(data, 2, 2))]
    output = {a}

    while index < #data do
        local n = f_string_byte(f_string_sub(data, index, index))
        local v = dictionary[bytes_to_number(f_string_sub(data, index + 1, index + n))] or (a .. f_string_sub(a, 1, 1))
        output[output_size] = v
        output_size = output_size + 1
        dictionary[dictionary_size] = a .. f_string_sub(v, 1, 1)
        dictionary_size = dictionary_size + 1
        a = v
        index = index + n + 1
    end

    return f_table_concat(output)
end
