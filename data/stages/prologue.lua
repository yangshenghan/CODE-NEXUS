return {
    objects     = {
        ground      = {
            x           = nexus.configures.graphics.width / 2,
            y           = nexus.configures.graphics.height - 50 / 2,
            width       = nexus.configures.graphics.width,
            height      = 50,
            bodyType    = 'static',
            draw        = function(...)
                love.graphics.setColor(72, 160, 14)
                love.graphics.polygon('fill', {select(2, ...)})
            end
        },
        sky         = {
            x           = nexus.configures.graphics.width / 2,
            y           = 50 / 2,
            width       = nexus.configures.graphics.width,
            height      = 50,
            bodyType    = 'static',
            draw        = function(...)
                love.graphics.setColor(72, 160, 14)
                love.graphics.polygon('fill', {select(2, ...)})
            end
        },
        leftwall    = {
            x           = 50 / 2,
            y           = nexus.configures.graphics.height / 2,
            width       = 50,
            height      = nexus.configures.graphics.height,
            bodyType    = 'static',
            draw        = function(...)
                love.graphics.setColor(72, 160, 14)
                love.graphics.polygon('fill', {select(2, ...)})
            end
        },
        rightwall   = {
            x           = nexus.configures.graphics.width - 50 / 2,
            y           = nexus.configures.graphics.height / 2,
            width       = 50,
            height      = nexus.configures.graphics.height,
            bodyType    = 'static',
            draw        = function(...)
                love.graphics.setColor(72, 160, 14)
                love.graphics.polygon('fill', {select(2, ...)})
            end
        },
        block1      = {
            x           = 200,
            y           = 550,
            width       = 50,
            height      = 100,
            density     = 5,
            bodyType    = 'dynamic',
            draw        = function(...)
                love.graphics.setColor(50, 50, 50)
                love.graphics.polygon('fill', {select(2, ...)})
            end
        },
        block2      = {
            x           = 200,
            y           = 400,
            width       = 100,
            height      = 50,
            density     = 2,
            bodyType    = 'dynamic',
            draw        = function(...)
                love.graphics.setColor(50, 50, 50)
                love.graphics.polygon('fill', {select(2, ...)})
            end
        }
    }
}
