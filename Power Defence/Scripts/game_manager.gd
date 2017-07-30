extends Node2D

var targets_basic = [
	load("res://Targets/basic_target.tscn"),
	load("res://Targets/basic_tank.tscn"),
	load("res://Targets/basic_speed.tscn")
]

var towers = {}

var current_energy = 50
var current_health = 100

var current_wave = 0
var max_specials
var specials_spawned = 0

var target_count
var targets_alive
var timer = Timer.new()

func _ready():
	get_node("energy_timer").connect("timeout", self, "update_energy")
	add_child(timer)
	calculate_wave()
	
func calculate_wave():
	get_node("gui/energy").set_text(str(current_energy))
	current_wave += 1
	target_count = ((((current_wave + 1)/2.0) + ((1 + 1)/1.5)) * 8);
	targets_alive = target_count
	specials_spawned = 0
	max_specials = target_count / 4 # 1 quarter specials
	wave_timer()
	
func wave_timer():
	timer.set_one_shot(true)
	if (current_wave == 1):
		timer.set_wait_time(15)
	else:
		timer.set_wait_time(3)
	timer.start()
	yield(timer, "timeout")
	spawn_targets()

func spawn_targets():
	spawn_target(0)
	target_count -= 1;
	
	timer.set_one_shot(true)
	timer.set_wait_time(rand_range(0, 1))
	timer.start()
	yield(timer, "timeout")
	
	if target_count > 0:
		spawn_targets()

func spawn_target(target):
	var target
	if (current_wave <= 2):
		target = targets_basic[0].instance()
	else:
		var target_id = floor(rand_range(0, 2.9));
		if (target_id > 0 && specials_spawned <= max_specials):
			target = targets_basic[target_id].instance()
		else:
			target = targets_basic[0].instance()
	target.health = target.health + (target.health / 10) * current_wave
	get_node("path").add_child(target)
	
func killed_target():
	targets_alive -= 1
	if targets_alive <= 0:
		calculate_wave()

func update_health():
	var decrease = 100 - current_health
	var percent_decreace = float(decrease) / float(100)
	get_node("gui/health").set_percentage((float(1.00) - (float(percent_decreace))))

func take_dmg(dmg):
	current_health -= dmg
	update_health()
	
	if (current_health <= 0):
		game_over()

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
			tower.poweroff()
			
	if towers.size() <= 0 && current_energy <= 0:
		game_over()
	elif powered_off == towers.size() && cant_afford_tower && towers.size() > 0:
		game_over()
	get_node("gui/energy").set_text(str(current_energy))

func place_tower(tower, tile):
	if (current_energy - tower.build_cost < 0):
		show_error("Not enough power!")
		return false
	current_energy -= tower.build_cost
	get_node("gui/energy").set_text(str(current_energy))
	towers[tile] = tower
	get_node("SamplePlayer").play("place_0" + str(floor(rand_range(1,4))))
	var tower_to_place = get_node("player").active_tower
	get_node("player").remove_child(tower_to_place)
	get_node("towers").add_child(tower_to_place)
	tower_to_place.activate()
	get_node("player").active_tower = null
	get_node("player").set_active_tower(-1)
	get_node("Camera2D").shake(rand_range(5, 7), rand_range(0.5, 1))

func shake(time, amount):
	get_node("Camera2D").shake(time, amount)

func select_tower(pos):
	if (pos in towers):
		if (towers[pos].energy_generation > 0):
			if (towers[pos].ready):
				towers[pos].collect()
				current_energy += towers[pos].energy_generation
				get_node("gui/energy").set_text(str(current_energy))
		get_node("gui").tower_selected(towers[pos])
		
func remove_tower(pos):
	if (pos in towers):
		current_energy -= towers[pos].build_cost
		get_node("gui/energy").set_text(str(current_energy))
		towers[pos].queue_free()
		towers.erase(pos)
		get_node("Camera2D").shake(rand_range(5, 7), rand_range(0.5, 1))
		get_node("SamplePlayer").play("remove_0" + str(floor(rand_range(1,4))))

func can_place(pos):
	return get_node("can_place").get_cell(pos.x, pos.y) && get_node("can_place").get_cell(pos.x, pos.y - 1) && get_node("can_place").get_cell(pos.x - 1, pos.y) && !pos in towers

func show_error(error):
	get_node("gui").show_error(error)
	get_node("SamplePlayer").play("error")
	
func game_over():
	get_node("StreamPlayer").stop()
	get_node("game_over").show()
	get_tree().set_pause(true)