extends Control

func _ready():
	get_node("towers/HButtonArray/solar_tower").connect("pressed", self, "basic_solar")
	get_node("towers/HButtonArray/basic_attack").connect("pressed", self, "basic_attack")

func basic_solar():
	select_tower(0)
	
func basic_attack():
	select_tower(1)

func select_tower(tower):
	get_parent().get_node("player").set_active_tower(tower)