nexus.input = {}

function nexus.input.initialize()
end

function nexus.input.isKeyDown(t)
    for _, v in pairs(t) do
        if love.keyboard.isDown(v) then
            return true
        end
    end
    return false
end

function nexus.input.isKeyUp()
    for _, v in pairs(t) do
        if love.keyboard.isUp(v) then
            return true
        end
    end
    return false
end

function nexus.input.isKeyTrigger(t)
    return false
end

function nexus.input.isKeyRepeat(t)
    return nexus.input.isKeyDown(t) and nexus.input.isKeyTrigger(t) 
end
