extends Node2D

var level_select = load("res://Menus/level_menu.tscn")

func _ready():
	get_node("menu/play").connect("pressed", self, "play")
	get_node("menu/exit").connect("pressed", self, "exit")
	get_node("menu/play").connect("mouse_enter", self, "item_hover")
	get_node("menu/exit").connect("mouse_enter", self, "item_hover")
	get_node("menu/music_vol").connect("value_changed", self, "music_vol")
	get_node("menu/sfx_vol").connect("value_changed", self, "sfx_vol")
	
	get_node("menu/music_vol").set_value(AudioServer.get_stream_global_volume_scale());
	get_node("menu/sfx_vol").set_value(AudioServer.get_fx_global_volume_scale())

func play():
	get_node("SamplePlayer").play("menu_select")
	while get_node("SamplePlayer").is_processing():
		pass
	get_node("menu").set_pos(Vector2(-999, -999))
	add_child(level_select.instance())
	
func music_vol(val):
	AudioServer.set_stream_global_volume_scale(val)
	pass

func sfx_vol(val):
	AudioServer.set_fx_global_volume_scale(val)
	pass
	
func exit():
	get_node("SamplePlayer").play("menu_select")
	while get_node("SamplePlayer").is_processing():
		pass
	get_tree().quit()
	
func item_hover():
	get_node("SamplePlayer").play("menu_hover")