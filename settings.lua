dofile("data/scripts/lib/mod_settings.lua") 

local mod_id = "da_minimap"
mod_settings_version = 1
mod_settings = {
	{
		id = "enable_minimap",
		ui_name = "Enable Minimap",
		value_default = true,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "minimap_positionx",
		ui_name = "Minimap Position X",
		value_default = -56,
		value_min = -128,
		value_max = 128,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "minimap_positiony",
		ui_name = "Minimap Position Y",
		value_default = 20,
		value_min = -128,
		value_max = 128,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "minimap_size",
		ui_name = "Minimap Size",
		value_default = 32,
		value_min = 16,
		value_max = 64,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "minimap_dot",
		ui_name = "Minimap Dot Size",
		value_default = 1,
		value_min = 1,
		value_max = 2,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "minimap_anchorx",
		ui_name = "Minimap Anchor X",
		value_default = 2,
		value_min = 0,
		value_max = 2,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "minimap_anchory",
		ui_name = "Minimap Anchor Y",
		value_default = 0,
		value_min = 0,
		value_max = 2,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "minimap_alpha",
		ui_name = "Minimap Background Alpha",
		value_default = 0.5,
		value_min = 0.0,
		value_max = 1.0,
		value_display_multiplier = 100,
		value_display_formatting = " $0%",
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "minimap_filtering",
		ui_name = "Minimap Pixel Filtering",
		value_default = true,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) 
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
