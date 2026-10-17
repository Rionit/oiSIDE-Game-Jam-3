shader_type spatial;
render_mode blend_add, depth_draw_opaque, cull_disabled, unshaded;

// Appearance
uniform vec4 albedo : source_color = vec4(1.0, 0.9, 0.5, 1.0);
uniform float intensity : hint_range(0.0, 10.0) = 2.5;
uniform float alpha_multiplier : hint_range(0.0, 1.0) = 0.6;

// Vertical Fade (0.0 = top/light source, 1.0 = bottom/fade out)
uniform float top_fade_start : hint_range(0.0, 1.0) = 0.0;
uniform float top_fade_end : hint_range(0.0, 1.0) = 0.2;
uniform float bottom_fade_start : hint_range(0.0, 1.0) = 0.7;
uniform float bottom_fade_end : hint_range(0.0, 1.0) = 1.0;

// Dust / Shimmer Noise (Optional)
uniform sampler2D noise_texture : hint_default_white, filter_linear_mipmap;
uniform vec2 noise_speed = vec2(0.0, 0.03);
uniform float noise_influence : hint_range(0.0, 1.0) = 0.3;

void fragment() {
    vec2 uv = UV;
    
    // 1. Vertical Gradient Fade
    float top_fade = smoothstep(top_fade_start, top_fade_end, uv.y);
    float bottom_fade = 1.0 - smoothstep(bottom_fade_start, bottom_fade_end, uv.y);
    float vertical_gradient = top_fade * bottom_fade;
    
    // 2. View-Angle Softening (Fresnel) so planes don't look razor-sharp edge-on
    float view_angle = abs(dot(normalize(NORMAL), normalize(VIEW)));
    float fresnel = pow(1.0 - view_angle, 1.5);
    fresnel = mix(0.5, 1.0, fresnel); // Soft base minimum
    
    // 3. Animated Noise / Dust Motes
    vec2 scrolled_uv = uv + noise_speed * TIME;
    float noise = texture(noise_texture, scrolled_uv).r;
    float noise_mod = mix(1.0, noise, noise_influence);
    
    // 4. Combine Final Color and Alpha
    ALBEDO = albedo.rgb * intensity;
    ALPHA = vertical_gradient * fresnel * noise_mod * alpha_multiplier * albedo.a;
}