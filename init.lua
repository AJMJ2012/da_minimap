dofile("mods/da_minimap/lib/script_utilities.lua")

script.append([[
uniform vec4 minimap_data;
uniform vec4 minimap_data2;
uniform vec4 minimap_data3;
]] ,"varying vec2 tex_coord_fogofwar;", "data/shaders/post_final.frag")

script.append([[
// generates a pixel art friendly texture coordinate ala https://csantosbh.wordpress.com/2014/01/25/manual-texture-filtering-for-pixelated-games-in-webgl/
// NOTE: texture filtering mode must be set to bilinear for this trick to work
vec2 pixel_art_filter_uv( vec2 uv, vec2 tex_size_pixels )
{
    const vec2 alpha = vec2(0.0); // 'alpha' affects the size of the smoothly filtered border between virtual (art) pixels.

    uv *= tex_size_pixels;
    {
        vec2 x = fract(uv);
        x = clamp(0.5 / alpha * x, 0.0, 0.5) + clamp(0.5 / alpha * (x - 1.0) + 0.5, 0.0, 0.5);
        uv = floor(uv) + x;
    }
    uv /= tex_size_pixels;

    return uv;
}
const float screenWidth = 427.0;
const float screenHeight = 242.0;
const vec2 screenSize = vec2(screenWidth, screenHeight);
]], "// utilities", "data/shaders/post_final.frag")

script.append([[
    // shader based minimap =====================================================================================================
	if (minimap_data.w == 1.0 && overlay_color.a <= 0.2) { // Menu Open (Hopefully just that)
		float map_size = minimap_data.z;
		float map_zoom = 1.0; // Kind of useless since the fog of war texture is limited
		vec2 map_tex_coord = vec2(gl_TexCoord[0].x, 1.0 - gl_TexCoord[0].y);
		float map_scale = map_size * map_zoom;
		vec2 map_pos = vec2(minimap_data.x, minimap_data.y);
		ivec2 map_anchor = ivec2(minimap_data2.x, minimap_data2.y);
		vec2 map_coord = (((map_tex_coord + ((map_anchor / 2.0) / screenSize * map_scale) - (map_anchor / 2.0) - (map_pos / screenSize)) * screenSize / map_scale) + (((map_anchor - 1.0) / (map_zoom * 2.0)) * (1.0 - map_zoom)));
		vec2 map_pixel_coord = map_coord;
		if (minimap_data3.x > 0.0) map_pixel_coord = pixel_art_filter_uv(map_coord, vec2(64.0));
		vec4 map_tex = clamp(texture2D(tex_fog, map_pixel_coord), 0.0, 1.0);
		vec2 map_border = vec2(2.0 / screenHeight) / (map_scale / 64.0);
		float map_dot = (minimap_data2.z * 2.0) / 256.0;
		vec2 edge = vec2(0.0, 1.0);
		edge.x -= (1.0 - map_zoom) * (0.5 / map_zoom);
		edge.y += (1.0 - map_zoom) * (0.5 / map_zoom);
		if (map_coord.x > edge.x && map_coord.x < edge.y
		&& map_coord.y > edge.x && map_coord.y < edge.y) {
			color.rgb *= minimap_data2.w;
			color.rgb += clamp(1.0 - vec3(map_tex.r) - (36.0/255.0), 0.0, 1.0) / (1.0 - (36.0/255.0));
			color.rgb *= 1.0 - overlay_color_blindness.a;
			// Border
			if (map_coord.x < edge.x + map_border.x || map_coord.y < edge.x + map_border.y
			|| map_coord.x > edge.y - map_border.x || map_coord.y > edge.y - map_border.y) {
				color.rgb = vec3(104, 62, 49) / 255.0;
			}
			// Center Dot
			if (map_coord.x > 0.5 - map_dot && map_coord.x < 0.5 + map_dot
			&& map_coord.y > 0.5 - map_dot && map_coord.y < 0.5 + map_dot ) {
				color.rgb = vec3(1.0, 0.0, 0.0);
			}
		}
	}

// ============================================================================================================
]], "// various debug visualizations================================================================================", "data/shaders/post_final.frag")

function HasSettingFlag(setting)
	if(setting ~= nil)then
		if(ModSettingGetNextValue(setting) ~= nil)then
			return ModSettingGetNextValue(setting)
		else
			return false
		end
	else
		print("HasSettingFlag: setting is nil")
	end
end

function OnPausedChanged( is_paused, is_inventory_pause )
	GameSetPostFxParameter( "minimap_data", math.floor(ModSettingGetNextValue("da_minimap.minimap_positionx")+0.5), math.floor(ModSettingGetNextValue("da_minimap.minimap_positiony")+0.5), math.floor(ModSettingGetNextValue("da_minimap.minimap_size")+0.5), HasSettingFlag("da_minimap.enable_minimap") and 1.0 or 0.0)
	GameSetPostFxParameter( "minimap_data2", math.floor(ModSettingGetNextValue("da_minimap.minimap_anchorx")+0.5), math.floor(ModSettingGetNextValue("da_minimap.minimap_anchory")+0.5), math.floor(ModSettingGetNextValue("da_minimap.minimap_dot")+0.5), ModSettingGetNextValue("da_minimap.minimap_alpha"))
	GameSetPostFxParameter( "minimap_data3", HasSettingFlag("da_minimap.minimap_filtering") and 1.0 or 0.0, 0.0, 0.0, 0.0)
end


function OnPlayerSpawned( player_entity )
	GameSetPostFxParameter( "minimap_data", math.floor(ModSettingGetNextValue("da_minimap.minimap_positionx")+0.5), math.floor(ModSettingGetNextValue("da_minimap.minimap_positiony")+0.5), math.floor(ModSettingGetNextValue("da_minimap.minimap_size")+0.5), HasSettingFlag("da_minimap.enable_minimap") and 1.0 or 0.0)
	GameSetPostFxParameter( "minimap_data2", math.floor(ModSettingGetNextValue("da_minimap.minimap_anchorx")+0.5), math.floor(ModSettingGetNextValue("da_minimap.minimap_anchory")+0.5), math.floor(ModSettingGetNextValue("da_minimap.minimap_dot")+0.5), ModSettingGetNextValue("da_minimap.minimap_alpha"))
	GameSetPostFxParameter( "minimap_data3", HasSettingFlag("da_minimap.minimap_filtering") and 1.0 or 0.0, 0.0, 0.0, 0.0)
end