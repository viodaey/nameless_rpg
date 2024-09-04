shader_type canvas_item;

uniform float time_factor = 1.0;
uniform vec2 amplitude = vec2(10.0, 5.0);

void vertex() {
    VERTEX.x += cos(TIME + VERTEX.x + VERTEX.y) * amplitude.x;
    VERTEX.y += sin(TIME + VERTEX.y + VERTEX.x) * amplitude.y;
    // Called for every vertex the material is visible on.
}

//void fragment() {
    //// Called for every pixel the material is visible on.
//}

//void light() {
    // Called for every pixel for every light affecting the CanvasItem.
    // Uncomment to replace the default light processing function with this one.
//}