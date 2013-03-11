nexus.input = {}

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

function nexus.input.initialize()
end
