nexus.object.player = {
}

local t_state = nil

local t_object = nil

local function create(instance)
    local body = love.physics.newBody(
        instance.world,
        nexus.configures.graphics.width / 2,
        nexus.configures.graphics.height / 2,
        'dynamic'
    )
    local shape = love.physics.newCircleShape(20)
    local fixture = love.physics.newFixture(body, shape, 1)

    t_state   = {
        rushing     = false,
        jumping     = false,
        attacking   = false
    }

    t_object = {
        body        = body,
        shape       = shape,
        fixture     = fixture
    }
end

local function delete(instance)
    t_state = nil
    t_object = nil
end

local function update(instance, dt)
end

local function draw(instance)
    love.graphics.setColor(193, 47, 14)
    love.graphics.circle('fill', t_object.body:getX(), t_object.body:getY(), t_object.shape:getRadius())
end

function nexus.object.player.rush(instance)
end

function nexus.object.player.jump(instance)
    if not t_state.jumping then
        -- self.player.body:applyForce(0, -400)
        t_object.body:applyForce(0, -40000)
    end
end

function nexus.object.player.attack(instance)
end

function nexus.object.player.left(instance)
    t_object.body:applyForce(-120000, 0)
end

function nexus.object.player.right(instance)
    t_object.body:applyForce(120000, 0)
end

function nexus.object.player.up(self)
    t_object.body:applyForce(0, -120000)
    -- t_object.body:setPosition(nexus.configures.graphics.width / 2, nexus.configures.graphics.height / 2)
end

function nexus.object.player.down(instance)
    t_object.body:applyForce(0, 120000)
end

function nexus.object.player.new(world)
    local instance = {
        create  = create,
        delete  = delete,
        update  = update,
        draw    = draw,
        world   = world
    }

    instance.object = nexus.core.load('object', 'player')

    return nexus.object.new(instance)
end
