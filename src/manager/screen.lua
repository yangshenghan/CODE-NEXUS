nexus.manager.screen = {}

local current = nil

local screens = {}

function nexus.manager.screen.initialize()
end

function nexus.manager.screen.change(screen)
    if current then
        current.leave(current)
    end
    current = screen
    if current then
        current.enter(current)
    end
end

function nexus.manager.screen.push(screen)
    if #screens > 0 then
        local last = table.last(screens)
        nexus.screen.setIdle(last, true)
        last.idleIn(last)
    elseif current then
        nexus.screen.setIdle(current, true)
        current.idleIn(current)
    end

    table.insert(screens, screen)
    screen.enter(screen)
end

function nexus.manager.screen.pop()
    if #screens == 0 then
        return
    end

    local popped = table.remove(screens)
    popped.leave(popped)

    if #screens > 0 then
        local last = table.last(screens)
        nexus.screen.setIdle(last, false)
        last.idleOut(last)
    elseif current then
        nexus.screen.setIdle(current, false)
        current.idleOut(current)
    end
end

function nexus.manager.screen.update(...)
    if current then
        current.update(current, ...)
    end

    for _, screen in ipairs(screens) do
        if not screen.idle then
            screen.update(screen, ...)
        end
    end
end

function nexus.manager.screen.draw(...)
    if current then
        current.draw(current, ...)
    end

    for _, screen in ipairs(screens) do
        screen.draw(screen, ...)
    end
end
