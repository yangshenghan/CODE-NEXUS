nexus.screen.error = {}

local m_message = 'There is an error occured!' 

local function draw(instance)
    love.graphics.print(m_message, nexus.system.defaults.width / 2, nexus.system.defaults.height / 2)
end

function nexus.screen.error.new(message)
    local instance = {
        draw    = draw
    }
    m_message = message
    return nexus.screen.new(instance)
end
