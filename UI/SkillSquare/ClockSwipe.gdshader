shader_type canvas_item;

// Clean Straight Clock Swipe
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float angle_offset : hint_range(0.0, 6.283) = 0.0;
uniform float feather : hint_range(0.0, 0.5) = 0.02;
uniform bool reversed = false;

// Appearance
uniform float darken_amount : hint_range(0.0, 1.0) = 0.7;
uniform vec4 dark_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

// Edge line
uniform bool show_edge_line = true;
uniform vec4 edge_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float edge_width : hint_range(0.0, 0.05) = 0.01;

void fragment() {
    // Position relative to center
    vec2 centered = UV - 0.5;
    
    // Get angle (0 at top, clockwise)
    float angle = atan(centered.y, centered.x);
    angle = angle + 3.14159 + 1.5708; // Rotate to make 0 at top
    float normalized_angle = fract(angle / (2.0 * 3.14159));
    normalized_angle = fract(normalized_angle + angle_offset);
    
    float prog = reversed ? 1.0 - progress : progress;
    
    // STRAIGHT CLOCK SWIPE - pure angle comparison
    float wipe = normalized_angle - prog;
    
    // Determine reveal status
    float reveal = smoothstep(0.0, feather, wipe);
    reveal = clamp(reveal, 0.0, 1.0);
    
    // Get texture
    vec4 tex = texture(TEXTURE, UV);
    
    // Darken the unrevealed portion
    vec4 darkened = tex;
    darkened.rgb = mix(darkened.rgb, dark_color.rgb, darken_amount);
    darkened.a = tex.a;
    
    // Blend based on reveal
    vec4 final_color = mix(darkened, tex, reveal);
    
    // Add edge line at the swipe boundary
    if (show_edge_line && progress > 0.0) {
        float edge_distance = abs(wipe);
        float edge_alpha = 1.0 - smoothstep(0.0, edge_width, edge_distance);
        final_color = mix(final_color, edge_color, edge_alpha * 0.8);
    }
    
    COLOR = final_color;
}