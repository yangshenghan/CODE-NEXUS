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
local lf                    = l.filesystem
local require               = require

local version               = require 'src.system.version'

-- / ---------------------------------------------------------------------- \ --
-- | Local variables                                                        | --
-- \ ---------------------------------------------------------------------- / --
local m_function_names      = {}

local f_math_log            = math.log
local f_math_ceil           = math.ceil
local f_math_floor          = math.floor
local f_table_concat        = table.concat
local f_string_sub          = string.sub
local f_string_char         = string.char

local m_log256              = f_math_log(256)

-- / ---------------------------------------------------------------------- \ --
-- | Private functions                                                      | --
-- \ ---------------------------------------------------------------------- / --
local function number_to_bytes(number)
    local length = f_math_ceil(f_math_log(number + 1) / m_log256)
    local bytes = {f_string_char(length)}
    for index = 2, length + 1 do
        bytes[index] = f_string_char(number % 256)
        number = f_math_floor(number / 256)
    end
    return f_table_concat(bytes)
end

local function initialize_cfunction_names(areas)
    local areas = areas or {
        '_G',
        'string',
        'table',
        'math',
        'io',
        'os',
        'coroutine',
        'package',
        'debug'
    }

    for k, v in pairs(areas) do
        local t = _G[v]
        if v == '_G' then
            v = ''
        else
            v  = v .. '.'
        end
        for k2, v2 in pairs(t) do
            if type(v2) == 'function' and not pcall(string.dump, v2) then
                m_function_names[v2] = v .. k2
            end
        end
    end
end

local function compress(data)
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

local function serialize(data, cfunctions)
    assert(data, 'argument #1 must be non-nil')

    if #m_function_names == 0 then initialize_cfunction_names() end
    cfunctions = cfunctions or m_function_names 
    assert(type(cfunctions) == 'table', 'argument #2 must be a table')

    local key_serializers
    local value_serializers

    local size = 2
    local buffer = {'function __deserialize() local _='}
    local listed = {}
    local psize = 1
    local pbuffer = {}

    local function construct_table_path(a, b)
        return a .. '[' .. key_serializers[type(b)](b) .. ']'
    end

    local function serialize_listed_entry(value, key)
        pbuffer[psize] = key
        pbuffer[psize + 1] = '='
        pbuffer[psize + 2] = value
        pbuffer[psize + 3] = ' '
        psize = psize + 4
    end

    local function error_serializer(a)
        error('cannot serialize "' .. type(a) .. '"')
    end

    local function number_serializer(a)
        return tostring(a)
    end

    local function boolean_serializer(a)
        return a and 'true' or 'false'
    end

    local function string_serializer(a)
        return string.format('%q', a)
    end

    local function function_serializer(a, cfunctions)
        return cfunctions[a] or string.format('loadstring(%q)', string.dump(a))
    end

    local function table_serializer(value, key)
        local metatable = getmetatable(value)
        if metatable then
            if metatable.__serialize then
                return metatable.__serialize(value)
            else
                error('cannot serialize an object (no __serialize function in metatable)')
            end
        else
            local seen = {}
            listed[value] = listed[value] or key
            buffer[size] = '{'
            size = size + 1
            for k, v in ipairs(value) do
                local path = type(v) == 'table' and construct_table_path(key, k) or nil
                seen[k] = true
                if not listed[v] then
                    local t = value_serializers[type(v)](v, path)
                    buffer[size] = t
                    buffer[size + 1] = ','
                    size = size + 2
                else
                    buffer[size] = 'nil,'
                    size = size + 1
                    serialize_listed_entry(listed[v], path)
                end
            end
            for k, v in pairs(value) do
                if not seen[k] then
                    local path = type(v) == 'table' and construct_table_path(key, k) or nil
                    if not listed[v] then
                        buffer[size] = '['
                        buffer[size + 1] = key_serializers[type(k)](k)
                        buffer[size + 2] = ']='
                        size = size + 3

                        local t = value_serializers[type(v)](v, path)
                        buffer[size] = t
                        buffer[size + 1] = ','
                        size = size + 2
                    else
                        serialize_listed_entry(listed[v], path)
                    end
                end
            end
            return '}'
        end
    end

    key_serializers     = {
        ['nil']         = error_serializer,
        ['userdata']    = error_serializer,
        ['thread']      = error_serializer,
        ['number']      = number_serializer,
        ['boolean']     = boolean_serializer,
        ['string']      = string_serializer,
        ['function']    = error_serializer,
        ['table']       = error_serializer
    }
    value_serializers   = {
        ['nil']         = error_serializer,
        ['userdata']    = error_serializer,
        ['thread']      = error_serializer,
        ['number']      = number_serializer,
        ['boolean']     = boolean_serializer,
        ['string']      = string_serializer,
        ['function']    = function_serializer,
        ['table']       = table_serializer
    }

    local t = value_serializers[type(data)](data, '_')
    buffer[size] = t
    buffer[size + 1] = ' '
    buffer[size + 2] = table.concat(pbuffer)
    buffer[size + 3] = 'return _ end'
    return table.concat(buffer)
end

return function(filename, data, identifier)
    local chunk = {
        identifier  = identifier,
        version     = version(),
        data        = data
    }
    return lf.write(filename, compress(serialize(chunk)))
end
