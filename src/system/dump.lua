return function(...)
    local serializer = require 'src/system/serialize'
    local contents = serializer(...) 
    print(contents)
    return contents
end
