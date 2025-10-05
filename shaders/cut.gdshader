shader_type canvas_item;

uniform float cut_value;
uniform float sprite_height = 42.0;

uniform float intensity : hint_range(0.0, 10.0) = 2.0;
uniform float frequency : hint_range(1.0, 60.0) = 12.0;

float rand(vec2 co) {
	return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void vertex() {
	float snap = floor(TIME * frequency) / frequency;
	vec2 jitter = vec2(rand(UV + snap), rand(UV + snap + 1.0));
	VERTEX.xy += (jitter - 0.5) * intensity;
}

void fragment() {
	float y_px = UV.y * sprite_height;
	
	if (y_px < cut_value) {
		discard;
	}
	
	COLOR = texture(TEXTURE, UV);
}

