shader_type canvas_item;

uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform float inner_radius : hint_range(0.0, 1.0) = 0.0;
uniform float outer_radius : hint_range(0.0, 2.0) = 1.0;
uniform vec3 vignette_rgb : source_color = vec3(0.0, 0.0, 0.0);

void fragment() {
	float x = abs(UV.r-.5)*2.0;
	float y = abs(UV.g-.5)*2.0;
	float q = 1.0-(1.0-sqrt(x*x+y*y)/outer_radius)/(1.0-inner_radius);
	COLOR = vec4(vignette_rgb, q*alpha);
}