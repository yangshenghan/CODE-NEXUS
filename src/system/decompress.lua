local f_table_concat = table.concat
local f_string_sub = string.sub
local f_string_byte = string.byte
local f_string_char = string.char

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
