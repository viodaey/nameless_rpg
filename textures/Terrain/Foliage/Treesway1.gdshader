shader_type spatial;
render_mode depth_prepass_alpha, unshaded;

uniform sampler2D main_texture : source_color; // Main texture for the quad
uniform bool pixel_mode = true;               // Enable pixelation
uniform float pixel_amount = 32.0;            // Pixelation level
uniform float distortion : hint_range(0.0, 0.1) = 0.01; // Distortion amount

uniform bool texture_noise_system = true;
uniform float noise_speed = 1.0;
uniform int noise_direction : hint_range(-1, 1) = -1;
uniform sampler2D noise_texture : source_color, repeat_enable;

uniform bool worley_noise_system = false;
uniform float worley_cell_density = 10.0;
uniform float worley_speed = 2.0;

uniform sampler2D mask_texture : source_color, filter_nearest;
uniform bool edge_and_mask = false;
uniform float alpha_value : hint_range(0.0, 1.0) = 1.0;

vec2 random(vec2 uv) {
    return vec2(fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453123));
}

float worley(vec2 uv, float columns, float rows, float time) {
    vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
    vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
    float minimum_dist = 1.0;

    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = random(index_uv + neighbor);
            point = vec2(cos(time * point.x * worley_speed), sin(time * point.y * worley_speed)) * 0.5 + 0.5;
            vec2 diff = neighbor + point - fract_uv;
            float dist = length(diff);
            minimum_dist = min(minimum_dist, dist);
        }
    }
    return minimum_dist;
}

void fragment() {
    vec4 uv_result = vec4(0.0);
    vec2 uv = UV;

    if (pixel_mode) {
        uv = floor(uv * pixel_amount) / pixel_amount;
    }

    if (texture_noise_system) {
        vec4 noise_uv = texture(noise_texture, uv + TIME * noise_speed * float(noise_direction));
        uv_result += noise_uv;
    }

    if (worley_noise_system) {
        float worley_value = worley(uv, worley_cell_density, worley_cell_density, TIME);
        vec4 result = texture(main_texture, vec2(worley_value));
        uv_result += result;
    }

    vec2 noise_uv = mix(uv, uv_result.rg, distortion);

    vec4 base_color = texture(main_texture, noise_uv);
    if (edge_and_mask) {
        vec4 mask_color = texture(mask_texture, noise_uv);
        base_color = mix(base_color, mask_color, mask_color.a);
    }

    ALBEDO = base_color.rgb;
    ALPHA = base_color.a * alpha_value;
}
