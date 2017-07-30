extends Node2D

func _ready():
	get_node("play").connect("pressed", self, "play")
	get_node("exit").connect("pressed", self, "exit")
	get_node("music_vol").connect("value_changed", self, "music_vol")
	get_node("sfx_vol").connect("value_changed", self, "sfx_vol")
	
	get_node("music_vol").set_value(AudioServer.get_stream_global_volume_scale());
	get_node("sfx_vol").set_value(AudioServer.get_fx_global_volume_scale())

func play():
	get_node("/root/globals").set_scene("res://Levels/test_level.tscn")
	
func music_vol(val):
	AudioServer.set_stream_global_volume_scale(val)
	pass

func sfx_vol(val):
	AudioServer.set_fx_global_volume_scale(val)
	pass
	
func exit():
	get_tree().quit()