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
