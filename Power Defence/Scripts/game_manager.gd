extends Node2D

var targets_basic = [
	load("res://Targets/basic_target.tscn")
]

var towers = {}

var current_energy = 50
var current_health = 100

func _ready():
	get_node("energy_timer").connect("timeout", self, "update_energy")
	spawn_target(0)

func update_health():
	var decrease = 100 - current_health
	var percent_decreace = float(decrease) / float(100)
	get_node("gui/health").set_percentage((float(1.00) - (float(percent_decreace))))

func take_dmg(dmg):
	current_health -= dmg
	update_health()
	
	if (current_health <= 0):
		show_error("Game Over!")

func update_energy():
	var cant_afford_tower = true
	var powered_off = 0
	for tower in towers.values():
		if (tower.powered && current_energy - tower.energy_cost >= 0):
			current_energy -= tower.energy_cost
		else:
			powered_off += 1;
			if (current_energy - tower.energy_cost >= 0):
				cant_afford_tower = false
			tower.powered = false
			
	if towers.size() <= 0 && current_energy <= 0:
		show_error("Game Over!")
	elif powered_off == towers.size() && cant_afford_tower && towers.size() > 0:
		show_error("Game Over!")
	get_node("gui/energy").set_text("Power: " + str(current_energy))

func spawn_target(target):
	var target = targets_basic[0].instance()
	get_node("path").add_child(target)

func place_tower(tower, tile):
	if (current_energy - tower.build_cost < 0):
		show_error("Not enough power!")
		return false
	current_energy -= tower.build_cost
	get_node("gui/energy").set_text("Power: " + str(current_energy))
	towers[tile] = tower
	var tower_to_place = get_node("player").active_tower
	get_node("player").remove_child(tower_to_place)
	get_node("towers").add_child(tower_to_place)
	tower_to_place.activate()
	get_node("player").active_tower = null
	get_node("player").set_active_tower(-1)

func select_tower(pos):
	if (pos in towers):
		if (towers[pos].energy_generation > 0):
			if (towers[pos].ready):
				towers[pos].collect()
				current_energy += towers[pos].energy_generation
				get_node("gui/energy").set_text("Power: " + str(current_energy))
		get_node("gui").tower_selected(towers[pos])

func can_place(pos):
	return get_node("can_place").get_cell(pos.x, pos.y) && get_node("can_place").get_cell(pos.x, pos.y - 1) && get_node("can_place").get_cell(pos.x - 1, pos.y) && !pos in towers

func show_error(error):
	get_node("gui").show_error(error)