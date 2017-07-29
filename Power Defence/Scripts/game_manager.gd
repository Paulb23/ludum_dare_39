extends Node2D

var towers = {}

func _ready():
	pass
	
func place_tower(tower, tile):
	towers[tile] = tower
	var tower_to_place = get_node("player").active_tower
	get_node("player").remove_child(tower_to_place)
	get_node("towers").add_child(tower_to_place)
	get_node("player").set_active_tower()