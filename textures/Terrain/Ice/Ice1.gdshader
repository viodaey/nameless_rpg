shader_type spatial;

uniform sampler2D albedo_tex;
uniform sampler2D normalmap_tex;
uniform sampler2D roughness_tex;

uniform sampler2D noise_tex;
uniform float depth;

void fragment() {
	vec2 base_uv = UV*5.0;
	mat3 tangent2view = mat3(TANGENT, NORMAL, BINORMAL);
	vec3 t_view = VIEW * tangent2view;
	vec2 move_uv = t_view.xz;
	float noise = texture(noise_tex, base_uv).r;
	move_uv += depth*noise;
	vec3 albedo_under = texture(albedo_tex, move_uv).rgb;
	ALBEDO = mix(texture(albedo_tex, base_uv).rgb, albedo_under, 0.6);
	NORMAL_MAP = texture(normalmap_tex, base_uv).rbg;
	ROUGHNESS = texture(roughness_tex, base_uv).r;
	
}