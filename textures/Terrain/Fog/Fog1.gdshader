shader_type fog;

uniform sampler2D noise_tex:repeat_enable;
uniform float noise_scale = 1.0;
uniform float flatness = 1.0;
uniform float density = 1.0;

uniform sampler2D grad_tex;

void fog() {
	vec2 move_uv = vec2(-0.2, -0.05)*TIME;
	float detail_noise = texture(noise_tex, WORLD_POSITION.xz*noise_scale + move_uv*0.5).r;
	detail_noise *= 0.2;
	float noise = texture(noise_tex, WORLD_POSITION.xz*noise_scale + move_uv).r;
	DENSITY = mix(1.0, noise, UVW.y*flatness);
	DENSITY *= step(0.0, -SDF)*density;
	vec3 col = texture(grad_tex, vec2(DENSITY, 0.5)).rgb;
	ALBEDO = vec3(col);
}
