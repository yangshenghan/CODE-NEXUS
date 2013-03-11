nexus.screen.title = {}

local m_cursor = 1

local t_menus = {
    'New Game',
    'Continue',
    'Exit'
}

local function enter(instance)
    m_cursor = 1 
end

local function leave(instance)
end

local function update(instance)
    if nexus.input.isKeyDown(nexus.configures.controls.up) then
        m_cursor = m_cursor - 1
        if m_cursor < 1 then
            m_cursor = #t_menus 
        end
    end

    if nexus.input.isKeyDown(nexus.configures.controls.down) then
        m_cursor = m_cursor + 1
        if m_cursor > #t_menus then
            m_cursor = 0
        end
    end
end

local function draw(instance)
    for index, title in pairs(t_menus) do
        love.graphics.setColor(255, 255, 255)
        if m_cursor == index then
            love.graphics.setColor(255, 255, 0)
        end
        love.graphics.print(tostring(title), 120, 480 + index * 20)
    end
end

function nexus.screen.title.new()
    local instance = {
        enter   = enter,
        leave   = leave,
        update  = update,
        draw    = draw
    }
    return nexus.screen.new(instance)
end
