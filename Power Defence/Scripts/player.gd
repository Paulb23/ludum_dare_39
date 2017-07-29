extends Node2D

var towers = [
	load("res://Towers/basic_solar.tscn")
]

var tile_size = 32
var active_tower = null

func _ready():
	tile_size = Globals.get("TILE_SIZE")
	set_active_tower()
	set_process_input(true)
	
func _input(event):
	if (active_tower != null):
		active_tower.set_pos(get_mouse_tile()*tile_size)
		if (event.type == InputEvent.MOUSE_BUTTON && event.button_mask == BUTTON_MASK_LEFT):
			get_parent().place_tower(active_tower, get_mouse_tile())
		
func set_active_tower():
	active_tower = towers[0].instance()
	active_tower.set_pos(get_local_mouse_pos())
	add_child(active_tower)
	
func get_mouse_tile():
	var mouse_pos = get_local_mouse_pos()
	mouse_pos.x = floor(mouse_pos.x / tile_size)
	mouse_pos.y = floor(mouse_pos.y / tile_size)
	return mouse_pos