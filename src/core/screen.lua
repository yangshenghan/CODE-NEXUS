nexus.screen   = {}

local default = {
    enter   = function(...) end,
    leave   = function(...) end,
    idleIn  = function(...) end,
    idleOut = function(...) end,
    update  = function(...) end,
    draw    = function(...) end,
    idle    = false
}

function nexus.screen.new(instance)
    for k, v in pairs(default) do
        if instance[k] == nil then
            instance[k] = v
        end
    end
    return instance
end

function nexus.screen.isIdle(instance)
    return instance.idle
end

function nexus.screen.setIdle(instance, idle)
    instance.idle = idle
end

function nexus.screen.toggleIdle(instance)
    instance.idle = not instance.idle
end
