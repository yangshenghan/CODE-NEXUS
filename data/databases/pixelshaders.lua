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
    ['blur_x']              = [[
extern number width = 0.0;
extern number intensity = 1.0;

vec4 effect(vec4 color, Image texture, vec2 tcoordinates, vec2 pcoordinates) {
    vec4 blur = vec4(0.0);
    number size = intensity / width;
    blur += Texel(texture, vec2(tcoordinates.x, tcoordinates.y - 4.0 * size)) * 0.05;
    blur += Texel(texture, vec2(tcoordinates.x, tcoordinates.y - 3.0 * size)) * 0.09;
    blur += Texel(texture, vec2(tcoordinates.x, tcoordinates.y - 2.0 * size)) * 0.12;
    blur += Texel(texture, vec2(tcoordinates.x, tcoordinates.y - size)) * 0.15;
    blur += Texel(texture, vec2(tcoordinates.x, tcoordinates.y)) * 0.16;
    blur += Texel(texture, vec2(tcoordinates.x, tcoordinates.y + size)) * 0.15;
    blur += Texel(texture, vec2(tcoordinates.x, tcoordinates.y + 2.0 * size)) * 0.12;
    blur += Texel(texture, vec2(tcoordinates.x, tcoordinates.y + 3.0 * size)) * 0.09;
    blur += Texel(texture, vec2(tcoordinates.x, tcoordinates.y + 4.0 * size)) * 0.05;
    return color * blur;
}
]],
    ['blur_y']              = [[
extern number height = 0.0;
extern number intensity = 1.0;

vec4 effect(vec4 color, Image texture, vec2 tcoordinates, vec2 pcoordinates) {
    vec4 blur = vec4(0.0);
    number size = intensity / height;
    blur += Texel(texture, vec2(tcoordinates.x - 4.0 * size, tcoordinates.y)) * 0.05;
    blur += Texel(texture, vec2(tcoordinates.x - 3.0 * size, tcoordinates.y)) * 0.09;
    blur += Texel(texture, vec2(tcoordinates.x - 2.0 * size, tcoordinates.y)) * 0.12;
    blur += Texel(texture, vec2(tcoordinates.x - size, tcoordinates.y)) * 0.15;
    blur += Texel(texture, vec2(tcoordinates.x, tcoordinates.y)) * 0.16;
    blur += Texel(texture, vec2(tcoordinates.x + size, tcoordinates.y)) * 0.15;
    blur += Texel(texture, vec2(tcoordinates.x + 2.0 * size, tcoordinates.y)) * 0.12;
    blur += Texel(texture, vec2(tcoordinates.x + 3.0 * size, tcoordinates.y)) * 0.09;
    blur += Texel(texture, vec2(tcoordinates.x + 4.0 * size, tcoordinates.y)) * 0.05;
    return color * blur;
}
]],
    ['glow']                = [[
extern number intensity = 1.0;

vec4 effect(vec4 color, Image texture, vec2 tcoordinates, vec2 pcoordinates) {
    vec4 glow = vec4(0.0);
    vec4 source = Texel(texture, tcoordinates);
    number size = intensity;

    for ( int x = -4 ; x <= 4 ; ++x ) {
        glow += Texel(texture, vec2(tcoordinates.x, tcoordinates.y + x * size)) * 0.15;
    }

    for ( int y = -4 ; y <= 4 ; ++y ) {
        glow += Texel(texture, vec2(tcoordinates.x - size, tcoordinates.y)) * 0.15;
    }

    return color * (source + glow - source * glow);
}
]],
}
