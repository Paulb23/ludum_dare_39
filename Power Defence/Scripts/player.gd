extends Node2D

var towers = [
	load("res://Towers/basic_solar.tscn"),
	load("res://Towers/basic_attack.tscn")
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
		var can_place = get_parent().can_place(get_mouse_tile())
		if (can_place):
			active_tower.get_node("Sprite").set_opacity(0.8)
			if (event.type == InputEvent.MOUSE_BUTTON && event.button_mask == BUTTON_MASK_LEFT):
				active_tower.get_node("Sprite").set_opacity(1)
				get_parent().place_tower(active_tower, get_mouse_tile())
		else:
			active_tower.get_node("Sprite").set_opacity(0.1)
		
func set_active_tower():
	active_tower = towers[1].instance()
	active_tower.set_pos(get_local_mouse_pos())
	add_child(active_tower)
	
func get_mouse_tile():
	var mouse_pos = get_local_mouse_pos()
	mouse_pos.x = floor(mouse_pos.x / tile_size)
	mouse_pos.y = floor(mouse_pos.y / tile_size)
	return mouse_pos