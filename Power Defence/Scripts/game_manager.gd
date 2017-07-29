extends Node2D

var targets_basic = [
	load("res://Targets/basic_target.tscn")
]

var towers = {}

func _ready():
	spawn_target(0)

func spawn_target(target):
	var target = targets_basic[0].instance()
	get_node("path").add_child(target)

func place_tower(tower, tile):
	towers[tile] = tower
	var tower_to_place = get_node("player").active_tower
	get_node("player").remove_child(tower_to_place)
	get_node("towers").add_child(tower_to_place)
	tower_to_place.activate()
	get_node("player").active_tower = null
	get_node("player").set_active_tower(-1)
	
func can_place(pos):
	return get_node("can_place").get_cell(pos.x, pos.y) && get_node("can_place").get_cell(pos.x, pos.y - 1) && get_node("can_place").get_cell(pos.x - 1, pos.y) && !pos in towers