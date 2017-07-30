extends Node2D

func _ready():
	get_node("menu").connect("pressed", self, "menu")
	get_node("exit").connect("pressed", self, "exit")
	get_node("menu").connect("mouse_enter", self, "item_hover")
	get_node("exit").connect("mouse_enter", self, "item_hover")

	
func menu():
	get_node("SamplePlayer").play("menu_select")
	while get_node("SamplePlayer").is_processing():
		pass
	hide()
	get_tree().set_pause(false)
	get_node("/root/globals").set_scene("res://Menus/main_menu.tscn")
	
func exit():
	get_node("SamplePlayer").play("menu_select")
	while get_node("SamplePlayer").is_processing():
		pass
	get_tree().quit()
	
func item_hover():
	get_node("SamplePlayer").play("menu_hover")
	
func show():
	set_pos(Vector2(0,0))
	get_node("waves").set_text(str(get_parent().current_wave-1))
	get_node("StreamPlayer").play(0)

func hide():
	set_pos(Vector2(-999,-999))