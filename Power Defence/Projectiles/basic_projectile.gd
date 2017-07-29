extends Area2D

var target
var speed = 150
var dmg = 10

func _ready():
	set_fixed_process(true)
	connect("area_enter", self, "attack")
	pass
	
func _fixed_process(delta):
	if (target != null):
		var vector = (target.get_parent().get_pos() - get_pos()).normalized()
		set_pos(get_pos() + vector * speed * delta)

func attack(body):
	if (body.get_name().find("target") == -1):
		return 
	body.get_parent().hit()
	queue_free()