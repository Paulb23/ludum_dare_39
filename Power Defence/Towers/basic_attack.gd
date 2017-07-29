extends Area2D

var activated = false
var has_target = false
var target_list = []
var target = null
var area = CircleShape2D.new()

func _ready():
	area.set_radius(32*3)
	get_node("CollisionShape2D").set_shape(area);

func _fixed_process(delta):
	if (!activated):
		return
	
	if (!has_target && target_list.size() > 0):
		target = target_list.back()
		if (target):
			has_target = true
			print("target selected")

func target_entered(body):
	if (body.get_name().find("target") == -1):
		return 
	print("adding target")
	target_list.push_back(body)
	
func target_exited(body):
	if (body.get_name().find("target") == -1):
		return 
	
	if (target == body):
		target = null
		has_target = false
	print("removing target")
	target_list.erase(body)
	
func _draw():
	if (!activated):
		draw_circle(get_node("Sprite").get_pos(), area.get_radius(), Color("11272726"))


func activate():
	connect("area_enter", self, "target_entered")
	connect("area_exit", self, "target_exited")
	activated = true
	set_fixed_process(true)
