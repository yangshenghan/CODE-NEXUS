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
local f_math_log = math.log
local f_math_ceil = math.ceil
local f_math_floor = math.floor
local f_table_concat = table.concat
local f_string_sub = string.sub
local f_string_char = string.char

local m_log256 = f_math_log(256)

local function number_to_bytes(number)
    local length = f_math_ceil(f_math_log(number + 1) / m_log256)
    local bytes = {f_string_char(length)}
    for index = 2, length + 1 do
        bytes[index] = f_string_char(number % 256)
        number = f_math_floor(number / 256)
    end
    return f_table_concat(bytes)
end

return function(data)
    local output = {}
    local output_size = 1
    local dictionary = {}
    local dictionary_size = 256

    for i = 0, 255 do
        dictionary[f_string_char(i)] = i
    end

    local a = ''
    for i = 1, #data do
        local b = f_string_sub(data, i, i)
        local ab = a .. b
        if dictionary[ab] then
            a = ab
        else
            dictionary[ab] = dictionary_size
            dictionary_size = dictionary_size + 1
            output[output_size] = number_to_bytes(dictionary[a])
            output_size = output_size + 1
            a = b
        end
    end
    output[output_size] = number_to_bytes(dictionary[a])

    return f_table_concat(output)
end
