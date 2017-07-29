extends Control

var selected_tower = null

func _ready():
	get_node("towers/HButtonArray/solar_tower").connect("pressed", self, "basic_solar")
	get_node("towers/HButtonArray/basic_attack").connect("pressed", self, "basic_attack")
	get_node("selected/power_button").connect("pressed", self, "toggle_power")
	
	get_node("error/error_timer").connect("timeout", self, "hide_error")

func basic_solar():
	select_tower(0)
	
func basic_attack():
	select_tower(1)

func select_tower(tower):
	get_parent().get_node("player").set_active_tower(tower)
	
func show_error(error):
	get_node("error").set_text(error)
	get_node("error/error_timer").start()
	
func hide_error():
	get_node("error").set_text("")
	
func toggle_power():
	selected_tower.powered = !selected_tower.powered
	tower_selected(selected_tower)
	
func tower_selected(tower):
	selected_tower = tower
	get_node("selected/stats").set_text(tower.name + "\nCost: " + str(tower.energy_cost) + "\nDmg: " + str(0)) 
	if (tower.powered):
		get_node("selected/power_button").set_text("Power Off")
	else:
		get_node("selected/power_button").set_text("Power On")