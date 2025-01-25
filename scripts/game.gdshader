shader_type canvas_item;

uniform vec2 light_position; // Position of the light source
uniform vec2 viewport_size;
uniform float aspect_ratio; // used for scaling
uniform float light_radius = 200.0; // Radius of the light
uniform float softness = 50.0; // Soft edge for the mask
const float xscaler = 1.1;


void fragment() {
    vec2 uv = SCREEN_UV; // Current pixel position on the screen
    vec2 light_uv = light_position; // Light position in screen space

	//correct based on AR
	uv = vec2(uv.x, uv.y / aspect_ratio  * xscaler);
    light_uv = vec2(light_uv.x, light_uv.y / aspect_ratio * xscaler);

    // Calculate the distance from the current pixel to the light source
    float dist = distance(uv, light_uv/viewport_size);

    // Create a smooth circular mask
    float mask = smoothstep(light_radius/ viewport_size.x,
                            (light_radius + softness) / viewport_size.x, dist);

    COLOR.a = mask;
}
