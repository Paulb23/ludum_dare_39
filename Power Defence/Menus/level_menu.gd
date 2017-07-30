extends Node2D

func _ready():
	get_node("menu").connect("pressed", self, "menu")
	get_node("exit").connect("pressed", self, "exit")
	
	get_node("tut").connect("pressed", self, "tut")
	get_node("level_1").connect("pressed", self, "level_1")
	
	get_node("menu").connect("mouse_enter", self, "item_hover")
	get_node("exit").connect("mouse_enter", self, "item_hover")
	get_node("tut").connect("mouse_enter", self, "item_hover")
	get_node("level_1").connect("mouse_enter", self, "item_hover")

func menu():
	get_node("SamplePlayer").play("menu_select")
	while get_node("SamplePlayer").is_processing():
		pass
	get_parent().get_node("menu").set_pos(Vector2(0,0))
	get_parent().get_node("SamplePlayer").play("menu_select")
	queue_free()
	
func exit():
	get_node("SamplePlayer").play("menu_select")
	while get_node("SamplePlayer").is_processing():
		pass
	get_tree().quit()
	
func tut():
	get_node("SamplePlayer").play("menu_select")
	while get_node("SamplePlayer").is_processing():
		pass
	get_node("/root/globals").set_scene("res://Levels/tutorial.tscn")
	
func level_1():
	get_node("SamplePlayer").play("menu_select")
	while get_node("SamplePlayer").is_processing():
		pass
	get_node("/root/globals").set_scene("res://Levels/test_level.tscn")
	
func item_hover():
	get_node("SamplePlayer").play("menu_hover")