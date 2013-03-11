return function(data)
    assert(type(data) == 'string')
    assert(loadstring(data))()
    return __deserialize()
end
