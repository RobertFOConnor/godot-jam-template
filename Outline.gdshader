shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec4 outline_color : source_color;
uniform float outline_width = 1.0; // pixels

void fragment() {
    vec4 base_tex = texture(SCREEN_TEXTURE, SCREEN_UV);
    ALBEDO = base_tex.rgb;
    ALPHA = base_tex.a;

    vec2 pixel_size = 1.0 / VIEWPORT_SIZE;

    for (int y = -int(outline_width); y <= int(outline_width); y++) {
        for (int x = -int(outline_width); x <= int(outline_width); x++) {
            vec2 uv = SCREEN_UV + vec2(float(x), float(y)) * pixel_size * outline_width;

            if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0)
                continue;

            vec4 tex = texture(SCREEN_TEXTURE, uv);

            if (tex.a == 0.0 && base_tex.a > 0.0) {
                ALBEDO = outline_color.rgb;
                ALPHA = 1.0;
            }
        }
    }
}
