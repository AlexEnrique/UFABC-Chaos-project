module map.tent_map;

import map.map;
/* import map.traits; */

auto tentMap(real mu = 2) {
    return new Map!((real x) => x < .5 ? mu * x : mu * (1 - x));
}
