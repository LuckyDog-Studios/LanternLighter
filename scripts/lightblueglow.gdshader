shader_type canvas_item;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV); // Get the texture color at this pixel

    // Check if the pixel is light blue (roughly)
    float blue_strength = tex_color.b - (tex_color.r + tex_color.g) * 0.5;

    if (blue_strength > 0.2) { // Only affect "blue-dominant" pixels
        tex_color.rgb += blue_strength * 1.5; // Boost glow effect
    }

    COLOR = tex_color;
}
