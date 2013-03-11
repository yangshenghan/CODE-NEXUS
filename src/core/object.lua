nexus.object   = {}

local default = {
    create  = function(...) end,
    delete  = function(...) end,
    update  = function(...) end,
    draw    = function(...) end
}

function nexus.object.new(instance)
    for k, v in pairs(default) do
        if instance[k] == nil then
            instance[k] = v
        end
    end
    instance.create(instance)
    return instance
end
