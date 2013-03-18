--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Atuhor: Yang Sheng Han <shenghan.yang@gmail.com>                       ]]--
--[[ Updates: 2013-03-18                                                    ]]--
--[[ License: zlib/libpng License                                           ]]--
--[[ ---------------------------------------------------------------------- ]]--
--[[ Copyright (c) 2012-2013 CODE NEXUS Development Team                    ]]--
--[[                                                                        ]]--
--[[ This software is provided 'as-is', without any express or implied      ]]--
--[[ warranty. In no event will the authors be held liable for any damages  ]]--
--[[ arising from the use of this software.                                 ]]--
--[[                                                                        ]]--
--[[ Permission is granted to anyone to use this software for any purpose,  ]]--
--[[ including commercial applications, and to alter it and redistribute it ]]--
--[[ freely, subject to the following restrictions:                         ]]--
--[[                                                                        ]]--
--[[ 1. The origin of this software must not be misrepresented; you must not]]--
--[[    claim that you wrote the original software. If you use this software]]--
--[[    in a product, an acknowledgment in the product documentation would  ]]--
--[[    be appreciated but is not required.                                 ]]--
--[[                                                                        ]]--
--[[ 2. Altered source versions must be plainly marked as such, and must not]]--
--[[    be misrepresented as being the original software.                   ]]--
--[[                                                                        ]]--
--[[ 3. This notice may not be removed or altered from any source           ]]--
--[[    distribution.                                                       ]]--
--[[ ********************************************************************** ]]--
local nexus = nexus

return {
    width       = 1280,
    height      = 720,
    objects     = {
        ground      = {
            x           = nexus.configures.graphics.width / 2,
            y           = nexus.configures.graphics.height - 50 / 2,
            width       = nexus.configures.graphics.width,
            height      = 50,
            bodyType    = 'static',
            render      = function(instance)
                love.graphics.setColor(72, 160, 14)
                love.graphics.rectangle('fill', instance.x, instance.y, instance.width, instance.height)
            end
        },
        sky         = {
            x           = nexus.configures.graphics.width / 2,
            y           = 50 / 2,
            width       = nexus.configures.graphics.width,
            height      = 50,
            bodyType    = 'static',
            render      = function(instance)
                love.graphics.setColor(72, 160, 14)
                love.graphics.rectangle('fill', instance.x, instance.y, instance.width, instance.height)
            end
        },
        leftwall    = {
            x           = 50 / 2,
            y           = nexus.configures.graphics.height / 2,
            width       = 50,
            height      = nexus.configures.graphics.height,
            bodyType    = 'static',
            render      = function(instance)
                love.graphics.setColor(72, 160, 14)
                love.graphics.rectangle('fill', instance.x, instance.y, instance.width, instance.height)
            end
        },
        rightwall   = {
            x           = nexus.configures.graphics.width - 50 / 2,
            y           = nexus.configures.graphics.height / 2,
            width       = 50,
            height      = nexus.configures.graphics.height,
            bodyType    = 'static',
            render      = function(instance)
                love.graphics.setColor(72, 160, 14)
                love.graphics.rectangle('fill', instance.x, instance.y, instance.width, instance.height)
            end
        },
        block1      = {
            x           = 200,
            y           = 550,
            width       = 50,
            height      = 100,
            density     = 5,
            bodyType    = 'dynamic',
            render      = function(instance)
                love.graphics.setColor(50, 50, 50)
                love.graphics.rectangle('fill', instance.x, instance.y, instance.width, instance.height)
            end
        },
        block2      = {
            x           = 200,
            y           = 400,
            width       = 100,
            height      = 50,
            density     = 2,
            bodyType    = 'dynamic',
            render      = function(instance)
                love.graphics.setColor(50, 50, 50)
                love.graphics.rectangle('fill', instance.x, instance.y, instance.width, instance.height)
            end
        }
    }
}
