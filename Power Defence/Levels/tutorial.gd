extends Node2D

var targets_basic = [
	load("res://Targets/basic_target.tscn")
]

var towers = {}

var current_energy = 999
var current_health = 100

var current_wave = 0

var example_spawn = false

var target_count
var targets_alive
var timer = Timer.new()
var wait_for_place = false

signal example_killed
signal tower_placed
signal power_collected
signal removed_tower
signal upgraded_tower

func _ready():
	get_node("energy_timer").connect("timeout", self, "update_energy")
	add_child(timer)
	get_node("energy_timer").stop()
	start_tutorial()
	
func start_tutorial():
	get_node("gui").disabled = true
	get_node("tut_text").show_text("\n    Welcome to Power Defence...")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    This is a tower defence game.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    The planet is running out of power, you control\n    the last source.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    You have been put in charge of the defence.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    The enemies will travel from left to right.")
	targets_alive = 2 
	example_spawn = true
	spawn_target(0)
	get_node("tut_text/Button").hide()
	yield(self, "example_killed")
	get_node("health_arrow").show()
	get_node("tut_text/Button").show()
	get_node("tut_text").show_text("\n    You will take damage if they make it all the way.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    It is game over if this drops below zero")
	yield(get_node("tut_text"), "next_text")
	get_node("health_arrow").hide()
	get_node("tut_text").show_text("\n    Your power is in the bottom left.")
	get_node("power_arrow").show()
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    Towers requre power, both to run and create.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    Every minute all towers will request power.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    if there is not enough they will deactivate.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    If you do not have sustainable power, the game will\n    end.")
	yield(get_node("tut_text"), "next_text")
	get_node("power_arrow").hide()
	get_node("tower_arrow").show()
	get_node("tut_text").show_text("\n    These are your towers.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    Hover over the icons for more information.")
	yield(get_node("tut_text"), "next_text")
	get_node("tower_arrow").hide()
	get_node("solar_arrow").show()
	get_node("tut_text/Button").hide()
	get_node("gui").allow_solar = true
	get_node("tut_text").show_text("\n    Select the Solar Tower.")
	yield(get_node("gui"), "solar_selected")
	get_node("solar_arrow").hide()
	get_node("tut_text").show_text("\n    Place it anywhere.")
	wait_for_place = true
	yield(self, "tower_placed")
	wait_for_place = false
	get_node("gui").allow_solar = false
	get_node("player").active_tower.queue_free()
	get_node("player").active_tower = null
	get_node("tut_text/Button").show()
	get_node("tut_text").show_text("\n    These towers create power.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    It can take some time...")
	get_node("tut_text/Button").hide()
	towers.values().front().get_node("generator_timer").set_wait_time(5)
	towers.values().front().get_node("generator_timer").start()
	yield(towers.values().front().get_node("generator_timer"), "timeout")
	get_node("gui").allow_selection = true
	get_node("tut_text").show_text("\n    It is complete, click the tower to collect the power.")
	yield(self, "power_collected")
	get_node("tut_text/Button").show()
	get_node("tut_text").show_text("\n    Clicking the tower also selcted it.")
	yield(get_node("tut_text"), "next_text")
	get_node("stats_arrow").show()
	get_node("tut_text").show_text("\n    With it selected, we can see its stats.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    It costs 1 power every minute and does 0 damage.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    We can also power it off for better power management.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text/Button").hide()
	get_node("gui").allow_power = true
	get_node("tut_text").show_text("\n    Turn off the tower.")
	yield(get_node("gui/selected/power_button"), "pressed")
	get_node("gui").allow_power = false
	get_node("tut_text/Button").show()
	get_node("tut_text").show_text("\n    When powered off it does nothing, and costs nothing.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    To turn it back on we need enough power. In this case\n    1.")
	yield(get_node("tut_text"), "next_text")
	get_node("gui").allow_power = true
	get_node("tut_text/Button").hide()
	get_node("tut_text").show_text("\n    Turn the tower back on.")
	yield(get_node("gui/selected/power_button"), "pressed")
	get_node("stats_arrow").hide()
	get_node("tut_text/Button").show()
	get_node("gui").allow_power = false
	get_node("tut_text").show_text("\n    Towers can also be upgraded.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    It costs power. Hover over to see the cost.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text/Button").hide()
	get_node("gui").allow_upgrade = true
	get_node("tut_text").show_text("\n    Upgrade the Tower.")
	yield(self, "upgraded_tower")
	get_node("tut_text/Button").show()
	get_node("gui").allow_upgrade = false
	get_node("tut_text").show_text("\n    See the updated stats and new cost.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    We can also remove towers.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text/Button").hide()
	get_node("gui").allow_remove = true
	get_node("tut_text").show_text("\n    Select the remove icon.")
	get_node("remove_arrow").show()
	yield(get_node("gui"), "remove_selected")
	get_node("gui").allow_remove = false
	get_node("remove_arrow").hide()
	get_node("tut_text").show_text("\n    Remove the Solar Tower")
	yield(self, "removed_tower")
	get_node("player").active_tower.queue_free()
	get_node("player").active_tower = null
	get_node("tut_text/Button").show()
	get_node("tut_text").show_text("\n    Removing a tower costs the same as bulding it.")
	yield(get_node("tut_text"), "next_text")
	get_node("tut_text").show_text("\n    This is the end of the tutorial. Good luck out there!")
	yield(get_node("tut_text"), "next_text")
	get_node("/root/globals").set_scene("res://Menus/main_menu.tscn")
	
	
func calculate_wave():
	get_node("gui/energy").set_text(str(current_energy))
	current_wave += 1
	target_count = ((((current_wave + 1)/2.0) + ((1 + 1)/1.5)) * 3);
	targets_alive = target_count
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
	timer.set_wait_time(rand_range(0, 3))
	timer.start()
	yield(timer, "timeout")
	
	if target_count > 0:
		spawn_targets()

func spawn_target(target):
	var target = targets_basic[0].instance()
	if example_spawn:
		target.speed = 0.2
	get_node("path").add_child(target)
	
func killed_target():
	if (example_spawn):
		example_spawn = false
		emit_signal("example_killed")
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
	
	if wait_for_place:
		emit_signal("tower_placed")
		
func remove_tower(pos):
	if (pos in towers):
		current_energy -= towers[pos].build_cost
		get_node("gui/energy").set_text(str(current_energy))
		towers[pos].queue_free()
		towers.erase(pos)
		get_node("Camera2D").shake(rand_range(5, 7), rand_range(0.5, 1))
		get_node("SamplePlayer").play("remove_0" + str(floor(rand_range(1,4))))
		emit_signal("removed_tower")

func upgrade(tower):
	if (tower == null):
		return
	var cost = round(tower.upgrade_cost / 2)
	if (current_energy >= cost):
		current_energy -= cost
		tower.upgrade_cost += 1
		get_node("gui/energy").set_text(str(current_energy))
		get_node("SamplePlayer").play("upgrade")
		emit_signal("upgraded_tower")
		return true
	else:
		show_error("Not Enough Power!")
		return false

func shake(time, amount):
	get_node("Camera2D").shake(time, amount)

func select_tower(pos):
	if (pos in towers):
		if (towers[pos].energy_generation > 0):
			if (towers[pos].ready):
				towers[pos].collect()
				current_energy += towers[pos].energy_generation
				get_node("gui/energy").set_text(str(current_energy))
				emit_signal("power_collected")
		get_node("gui").tower_selected(towers[pos])

func can_place(pos):
	return get_node("can_place").get_cell(pos.x, pos.y) && get_node("can_place").get_cell(pos.x, pos.y - 1) && get_node("can_place").get_cell(pos.x - 1, pos.y) && !pos in towers

func show_error(error):
	get_node("gui").show_error(error)
	get_node("SamplePlayer").play("error")
	
func game_over():
	get_node("StreamPlayer").stop()
	get_node("game_over").show()
	get_tree().set_pause(true)