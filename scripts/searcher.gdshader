shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
  	vec4 background = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgba;
	vec4 mask = textureLod(TEXTURE, UV, 0.0).rgba;
	
	if(mask.a != 0.0){
		background.r = 1.0 - background.r;
		background.g = 1.0 - background.g;
		background.b = 1.0 - background.b;
		COLOR.rgba = background;
	}
}
