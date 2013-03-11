nexus.screen.stage = {
    stages  = {}
}

local gravity = 9.81;

local player = nil

local function begin_contact(a, b, collision)
end

local function end_contact(a, b, collision)
end

local function pre_solve(a, b, collision)
end

local function post_solve(a, b, collision)
end

local function enter(instance)
    instance.world = love.physics.newWorld(0, gravity * love.physics.getMeter(), true)
    instance.objects = nexus.manager.object.getObjects()

    instance.world:setCallbacks(begin_contact, end_contact, pre_solve, post_solve)

    player = nexus.object.player.new(instance.world)

    for _, data in pairs(instance.stage.objects) do
        local object = {}
        object.body = love.physics.newBody(instance.world, data.x, data.y, data.bodyType or 'static')
        object.shape = love.physics.newRectangleShape(data.width, data.height)
        object.fixture = love.physics.newFixture(object.body, object.shape, data.density or 0)
        object.draw = data.draw or function(...) end
        object.update = data.update or function(...) end
        nexus.manager.object.attachObject(object)
    end

    love.graphics.setBackgroundColor(104, 136, 248)
end

local function leave(instance)
    player.delete(player)

    instance.world = nil
    player = nil
end

local function update(instance, dt)
    if instance.idle then return end

    instance.world.update(instance.world, dt)

    if nexus.input.isKeyDown(nexus.configures.controls.rush) then
        nexus.console.showDebugMessage('Player rush')
        nexus.object.player.rush(player)
    end

    if nexus.input.isKeyDown(nexus.configures.controls.jump) then
        nexus.console.showDebugMessage('Player jump')
        nexus.object.player.jump(player)
    end

    if nexus.input.isKeyDown(nexus.configures.controls.attack) then
        nexus.console.showDebugMessage('Player attack')
        nexus.object.player.attack(player)
    end

    if nexus.input.isKeyDown(nexus.configures.controls.left) then
        nexus.object.player.left(player)
    end

    if nexus.input.isKeyDown(nexus.configures.controls.right) then
        nexus.object.player.right(player)
    end

    if nexus.input.isKeyDown(nexus.configures.controls.up) then
        nexus.object.player.up(player)
    end

    if nexus.input.isKeyDown(nexus.configures.controls.down) then
        nexus.object.player.down(player)
    end

    player.update(player, dt)
    if #instance.objects > 0 then
        for _, v in pairs(instance.objects) do
            v:update(dt)
        end
    end
end

local function draw(instance)
    player.draw(player)
    if #instance.objects > 0 then
        for _, v in pairs(instance.objects) do
            v:draw(v.body:getWorldPoints(v.shape:getPoints()))
        end
    end
end

function nexus.screen.stage.new(stage)
    local instance = {
        enter   = enter,
        leave   = leave,
        update  = update,
        draw    = draw
    }

    instance.stage = nexus.core.load('stage', stage)

    return nexus.screen.new(instance)
end
