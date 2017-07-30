extends Control

var selected_tower = null
var disabled = false
var allow_solar = false
var allow_remove = false
var allow_selection = false
var allow_power = false
var allow_upgrade = false

signal solar_selected
signal remove_selected

func _ready():
	get_node("towers/HButtonArray/solar_tower").connect("pressed", self, "basic_solar")
	get_node("towers/HButtonArray/basic_attack").connect("pressed", self, "basic_attack")
	get_node("towers/HButtonArray/fast_attack").connect("pressed", self, "fast_attack")
	get_node("towers/HButtonArray/splitter_attack").connect("pressed", self, "splitter_attack")
	get_node("towers/HButtonArray/remove_tower").connect("pressed", self, "remove_tower")
	get_node("selected/power_button").connect("pressed", self, "toggle_power")
	get_node("selected/upgrade_button").connect("pressed", self, "upgrade")
	
	get_node("error/error_timer").connect("timeout", self, "hide_error")

func basic_solar():
	select_tower(0)
	
func basic_attack():
	select_tower(1)
	
func fast_attack():
	select_tower(2)
	
func remove_tower():
	select_tower(3)
	
func splitter_attack():
	select_tower(4)
	
func upgrade():
	if (disabled && !allow_upgrade):
		return
	if get_parent().upgrade(selected_tower):
		if selected_tower.name == "Solar Tower":
			selected_tower.energy_generation += 3
		else:
			selected_tower.dmg += 1
		selected_tower.energy_cost += 1
		tower_selected(selected_tower)

func select_tower(tower):
	if disabled:
		if allow_solar && tower == 0:
			get_parent().get_node("player").set_active_tower(tower)
			emit_signal("solar_selected")
		if allow_remove && tower == 3:
			get_parent().get_node("player").set_active_tower(tower)
			emit_signal("remove_selected")
		return
	get_parent().get_node("player").set_active_tower(tower)
	
func show_error(error):
	get_node("error").set_text(error)
	get_node("error/error_timer").start()
	
func hide_error():
	get_node("error").set_text("")
	
func toggle_power():
	if disabled && !allow_power:
		return
	if (selected_tower.powered):
			selected_tower.poweroff()
	else:
		if get_parent().current_energy >= selected_tower.energy_cost:
			selected_tower.poweron()
		else:
			get_parent().show_error("Not Enough Power!")
	tower_selected(selected_tower)
	
func tower_selected(tower):
	if disabled && !allow_selection:
		return
	if selected_tower != null:
		selected_tower.selected = false
		selected_tower.update()
	selected_tower = tower
	selected_tower.selected = true
	selected_tower.update()
	if tower.name == "Solar Tower":
		get_node("selected/stats").set_text(tower.name + "\nCost: " + str(tower.energy_cost) + "\nGen: " + str(tower.energy_generation)) 
	else:
		get_node("selected/stats").set_text(tower.name + "\nCost: " + str(tower.energy_cost) + "\nDmg: " + str(tower.dmg)) 
	if (tower.powered):
		get_node("selected/power_button").set_text("Power Off")
	else:
		get_node("selected/power_button").set_text("Power On")
	get_node("selected/upgrade_button").set_tooltip("Cost: " + str(tower.upgrade_cost / 2))