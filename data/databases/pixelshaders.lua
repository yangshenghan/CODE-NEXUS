--[[ ********************************************************************** ]]--
--[[ [CODE NEXUS]                                                           ]]--
--[[                                                                        ]]--
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

return {
    ['horizontal_blur']     = [[
extern number unit = 0.0;

const number kernels[5] = number[](0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162);

vec4 effect(vec4 color, Image texture, vec2 coordinate, vec2 position) {
    vec4 blur = Texel(texture, coordinate) * kernels[0];
    for ( int index = 1 ; index < 5 ; ++index ) {
        blur += Texel(texture, vec2(coordinate.x - index * unit, coordinate.y)) * kernels[index];
        blur += Texel(texture, vec2(coordinate.x + index * unit, coordinate.y)) * kernels[index];
    }
    return color * blur;
}
]],
    ['vertical_blur']       = [[
extern number unit = 0.0;

const number kernels[5] = number[](0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162);

vec4 effect(vec4 color, Image texture, vec2 coordinate, vec2 position) {
    vec4 blur = Texel(texture, coordinate) * kernels[0];
    for ( int index = 1 ; index < 5 ; ++index ) {
        blur += Texel(texture, vec2(coordinate.x, coordinate.y - index * unit)) * kernels[index];
        blur += Texel(texture, vec2(coordinate.x, coordinate.y + index * unit)) * kernels[index];
    }
    return color * blur;
}
]],
    ['glow']                = [[
extern number intensity = 1.0;

vec4 effect(vec4 color, Image texture, vec2 coordinate, vec2 position) {
    vec4 glow = vec4(0.0);
    vec4 source = Texel(texture, coordinate);
    number size = intensity;

    for ( int x = -4 ; x <= 4 ; ++x ) {
        glow += Texel(texture, vec2(coordinate.x, coordinate.y + x * size)) * 0.15;
    }

    for ( int y = -4 ; y <= 4 ; ++y ) {
        glow += Texel(texture, vec2(coordinate.x - size, coordinate.y)) * 0.15;
    }

    return color * (source + glow - source * glow);
}
]],
}
